//
//  MessageCommentsViewModel.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/4/24.
//

import Foundation

class MessageCommentsViewModel {
    lazy var commentsList = [MessageCommentCellViewModel]()
    lazy var listService = MessageCommentsService()
    
    private var subCommentsModel = SubCommentsViewModel.generateSubCommentsViewModels()

    private var currentPage: Int

    init() {
        currentPage = 1
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

private enum SubCommentsType {
    case received
    case mentioned
    case send
}

private class SubCommentsViewModel {
    var commentsList = [MessageCommentCellViewModel]()
    var currentPage: Int = 1
    var requestURL: String
    
    init(type: SubCommentsType) {
        switch type {
        case .received:
            requestURL = URLSettings.messageComments
        case .mentioned:
            requestURL = URLSettings.messageMentionsComments
        case .send:
            requestURL = URLSettings.messageMyComments
        }
    }
    
    class func generateSubCommentsViewModels() -> [SubCommentsViewModel] {
        var array = [SubCommentsViewModel]()
        array.append(SubCommentsViewModel(type: .received))
        array.append(SubCommentsViewModel(type: .mentioned))
        array.append(SubCommentsViewModel(type: .received))
        return array
    }
}
