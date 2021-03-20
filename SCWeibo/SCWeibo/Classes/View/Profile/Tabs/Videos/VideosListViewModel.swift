//
//  VideosListViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/17.
//

import Foundation

class VideosListViewModel {
    lazy var videoList = [VideoCellViewModel]()

    var sinceId: String?

    init() {
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {


        VideosListService.loadStatus(since_id: nil) { isSuccess, data in
            if !isSuccess {
                completion(false, false)
                return
            }

            if let cardListInfo: Dictionary<AnyHashable, Any> = data?.sc.dictionary(for: "cardlistInfo") {
                self.sinceId = cardListInfo.sc.string(for: "since_id")
            }

            guard let cards: Array<Dictionary<AnyHashable, Any>> = data?.sc.array(for: "cards") else {
                completion(false, false)
                return
            }

            var cellViewModels = [VideoCellViewModel]()
            for card in cards {
                let videoModel = VideoResponse(dict: card)
                let viewModel = VideoCellViewModel(with: videoModel)
                cellViewModels.append(viewModel)
            }

            if loadMore {
                self.videoList += cellViewModels
            } else {
                self.videoList = cellViewModels
            }

            completion(isSuccess, true)
        }
    }
}
