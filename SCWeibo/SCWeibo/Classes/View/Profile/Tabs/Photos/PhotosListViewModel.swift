//
//  PhotosListViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/22.
//

import Foundation

class PhotosListViewModel {
    lazy var photos = [PhotoCellViewModel]()

    init() {
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        PhotosListService.loadStatus(since_id: nil) { isSuccess, data in
            if !isSuccess {
                completion(false, false)
                return
            }

            guard let cards: Array<Dictionary<AnyHashable, Any>> = data?.sc.array(for: "cards") else {
                completion(false, false)
                return
            }

            var allPics = [[AnyHashable: Any]]()
            for card in cards {
                guard let pics: [[AnyHashable: Any]] = card.sc.array(for: "pics") else { continue }
                allPics.append(contentsOf: pics)
            }

            var cellViewModels = [PhotoCellViewModel]()
            for pic in allPics {
                let photoModel = PhotoResponse(dict: pic)
                let viewModel = PhotoCellViewModel(with: photoModel)
                cellViewModels.append(viewModel)
            }

            if loadMore {
                self.photos += cellViewModels
            } else {
                self.photos = cellViewModels
            }

            completion(isSuccess, true)
        }
    }
}
