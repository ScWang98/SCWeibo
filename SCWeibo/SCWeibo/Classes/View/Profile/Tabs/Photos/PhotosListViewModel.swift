//
//  PhotosListViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/22.
//

import Foundation

class PhotosListViewModel {
    lazy var photos = [PhotoCellViewModel]()
    var listService = PhotosListService()
    private var currentPage: Int

    init() {
        currentPage = 1
    }
    
    func config(withUserId userId: String?) {
        listService.userId = userId
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        let page = loadMore ? currentPage + 1 : 1
        listService.loadStatus(page: page) { isSuccess, data in
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
                self.currentPage += 1
            } else {
                self.photos = cellViewModels
                self.currentPage = 1
            }

            completion(isSuccess, true)
        }
    }
}
