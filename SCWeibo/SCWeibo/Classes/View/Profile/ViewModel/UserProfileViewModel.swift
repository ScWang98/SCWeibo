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

    func tabRefresh(with completion: () -> Void)
}

class UserProfileViewModel {
    var tabViewModels = { () -> [UserProfileTabViewModel] in
        var models = [UserProfileTabViewModel]()
        models.append(UserProfileStatusTabViewModel())
        models.append(UserProfileVideosTabViewModel())
        models.append(UserProfilePhotosTabViewModel())
        return models
    }()

    var tabNames: [String] {
        var names = [String]()
        for tab in tabViewModels {
            names.append(tab.tabName)
        }
        return names
    }

    var user: UserResponse?
    var id: Int?
    var screenName: String?
    var avatar: URL?
    var avatarHD: URL?
    var description: String?
    var genderImage: UIImage?
    var statusesCountStr: String?
    var followersCountStr: String?
    var followCountStr: String?

    init(with routeParams: Dictionary<AnyHashable, Any>?) {
        if let routeParams = routeParams,
           let user = routeParams["user"] as? UserResponse {
            parseUserResponse(user: user)
        } else if let user = AccountManager.shared.user {
            parseUserResponse(user: user)
        }
    }

    func fetchUserInfo(completion: @escaping () -> Void) {
        UserProfileService.fetchUserInfo { user in
            guard let user = user else {
                return
            }

            self.parseUserResponse(user: user)
            completion()
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
