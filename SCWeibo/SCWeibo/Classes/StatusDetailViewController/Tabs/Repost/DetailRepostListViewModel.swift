//
//  DetailRepostListViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import Foundation

class DetailRepostListViewModel {
    lazy var repostList = [DetailRepostCellViewModel]()

    var sinceId: String?

    init() {
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        DetailRepostListService.loadStatus(since_id: nil) { (isSuccess, repostModels) in
            if !isSuccess {
                completion(false, false)
                return
            }

            var cellViewModels = [DetailRepostCellViewModel]()
            for repostModel in repostModels {
                let viewModel = DetailRepostCellViewModel(with: repostModel)
                cellViewModels.append(viewModel)
            }

            if loadMore {
                self.repostList += cellViewModels
            } else {
                self.repostList = cellViewModels
            }

            completion(isSuccess, true)
        }
    }
}
