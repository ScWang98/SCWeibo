//
//  DetailCommentListViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Foundation

class DetailCommentListViewModel {
    lazy var commentList = [DetailCommentCellViewModel]()

    var sinceId: String?

    init() {
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        DetailCommentListService.loadStatus(since_id: nil) { isSuccess, commentModels in
            if !isSuccess {
                completion(false, false)
                return
            }

            var cellViewModels = [DetailCommentCellViewModel]()
            for commentModel in commentModels {
                let viewModel = DetailCommentCellViewModel(with: commentModel)
                cellViewModels.append(viewModel)
            }

            if loadMore {
                self.commentList += cellViewModels
            } else {
                self.commentList = cellViewModels
            }

            completion(isSuccess, true)
        }
    }
}
