//
//  UserProfileViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/5.
//

import UIKit

protocol UserProfileTabViewModel {
    var tabName: String { get }
    var tabViewController: UIViewController? { get }
    var tabView: UIView { get }
    var tabScrollView: UIScrollView { get }

    func tabRefresh(with completion: (() -> Void)?)
}

class UserProfileViewModel {
    let statusTabViewModel = UserProfileStatusTabViewModel()
    let videosTabViewModel = UserProfileVideosTabViewModel()
    let photosTabViewModel = UserProfilePhotosTabViewModel()

    lazy var tabViewModels: [UserProfileTabViewModel] = {
        var models = [UserProfileTabViewModel]()
        models.append(self.statusTabViewModel)
        models.append(self.videosTabViewModel)
        models.append(self.photosTabViewModel)
        return models
    }()

    lazy var tabNames: [String] = {
        tabViewModels.map { tabViewModel -> String in
            tabViewModel.tabName
        }
    }()

    var user: UserResponse?
    var id: Int?
    var screenName: String?
    var avatar: URL?
    var avatarHD: URL?
    var description: String?
    var genderImage: UIImage?
    var location: String?
    var statusesCountStr: String?
    var followersCountStr: String?
    var followCountStr: String?

    var profileService = UserProfileService()

    init() {
    }

    convenience init(with routeParams: Dictionary<AnyHashable, Any>?) {
        self.init()

        if let routeParams = routeParams,
           let userInfo: [AnyHashable: Any] = routeParams.sc.dictionary(for: RouterParameterUserInfo),
           let user = userInfo["user"] as? UserResponse {
            parseUserResponse(user: user)
        } else if let user = AccountManager.shared.user {
            parseUserResponse(user: user)
        }

        var userId: String?
        if let id = id {
            userId = String(id)
        }
        statusTabViewModel.viewController.config(withUserId: userId)
    }

    func fetchUserInfo(completion: @escaping () -> Void) {
        guard let userId = id else {
            return
        }
        profileService.fetchUserInfo(with: userId) { user in
            guard let user = user else {
                completion()
                return
            }

            self.parseUserResponse(user: user)
            completion()
        }
    }
    
    func reloadAllTabsContent() {
        for viewModel in tabViewModels {
            viewModel.tabRefresh(with: nil)
        }
    }
}

private extension UserProfileViewModel {
    func parseUserResponse(user: UserResponse) {
        self.user = user
        id = user.id
        screenName = user.screenName
        if let urlString = user.avatar {
            avatar = URL(string: urlString)
        } else {
            avatar = nil
        }
        if let urlString = user.avatar {
            avatarHD = URL(string: urlString)
        } else {
            avatarHD = nil
        }
        if let description = user.description,
           description.count > 0 {
            self.description = description
        } else {
            description = "你还没有描述"
        }
        genderImage = user.gender == "m" ? UIImage(named: "Male_Normal") : UIImage(named: "Female_Normal")
        location = user.location
        if let statusesCount = user.statusesCount {
            statusesCountStr = String(format: "%d 微博", statusesCount)
        } else {
            statusesCountStr = "---"
        }
        if let followersCount = user.followersCount {
            followersCountStr = String(format: "%d 粉丝", followersCount)
        } else {
            followersCountStr = "---"
        }
        if let followCount = user.followCount {
            followCountStr = String(format: "%d 正在关注", followCount)
        } else {
            followCountStr = "---"
        }
    }
}
