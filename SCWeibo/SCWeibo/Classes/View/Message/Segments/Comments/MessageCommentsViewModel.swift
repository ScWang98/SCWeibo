//
//  MessageCommentsViewModel.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/4/24.
//

import Foundation

class MessageCommentsViewModel {
    lazy var commentsList = [MessageCommentCellViewModel]()
    var listService: MessageCommentsService
    
    private var currentPage: Int = 1
    
    init(type: MessageCommentsListType) {
        listService = MessageCommentsService(type: type)
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        let page = loadMore ? currentPage + 1 : 1
        listService.loadStatus(page: page) { isSuccess, commentModels in
            guard let commentModels = commentModels,
                  isSuccess else {
                completion(false, false)
                return
            }

            var cellViewModels = [MessageCommentCellViewModel]()
            for commentModel in commentModels {
                let viewModel = MessageCommentCellViewModel(with: commentModel)
                cellViewModels.append(viewModel)
            }

            if loadMore {
                self.commentsList += cellViewModels
                self.currentPage += 1
            } else {
                self.commentsList = cellViewModels
                self.currentPage = 1
            }

            completion(isSuccess, true)
        }
    }
}
