//
//  DetailCommentListViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Foundation

class DetailCommentListViewModel {
    lazy var commentList = [DetailCommentCellViewModel]()
    lazy var listService = DetailCommentListService()

    init() {
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        listService.loadStatus(loadMore: loadMore) { isSuccess, commentModels in
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
    
    func config(statusId: String?) {
        listService.statusId = statusId
    }
}
