//
//  ProfileFollowViewModel.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/17.
//

import Foundation

class ProfileFollowViewModel {
    var userId: Int
    lazy var usersList = [ProfileFollowUserCellViewModel]()
    var service: ProfileFollowService
    var sinceId: Int = 0
    
    private var currentPage: Int = 1

    init(type: ProfileFollowType, userId: Int) {
        self.userId = userId
        service = ProfileFollowService(type: type)
    }

    func loadStatus(loadMore: Bool, completion: @escaping (_ isSuccess: Bool, _ needRefresh: Bool) -> Void) {
        let page = loadMore ? currentPage + 1 : 1

        service.requestFollowList(userId: userId, page: page, sinceId: sinceId) { (success, sinceId, userModels) in
            guard let userModels = userModels,
                  success else {
                completion(false, false)
                return
            }

            var cellViewModels = [ProfileFollowUserCellViewModel]()
            for userModel in userModels {
                let viewModel = ProfileFollowUserCellViewModel(with: userModel)
                cellViewModels.append(viewModel)
            }

            if loadMore {
                self.usersList += cellViewModels
                self.currentPage += 1
            } else {
                self.usersList = cellViewModels
                self.currentPage = 1
            }
            self.sinceId = sinceId

            completion(success, true)
        }
    }
}

