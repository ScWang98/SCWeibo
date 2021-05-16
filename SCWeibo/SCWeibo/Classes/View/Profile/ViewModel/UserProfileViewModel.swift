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

    var isSelf: Bool = false
    var user: UserResponse?
    var id: Int?
    var screenName: NSAttributedString?
    var avatar: URL?
    var avatarHD: URL?
    var description: String?
    var genderImage: UIImage?
    var location: NSAttributedString?
    var statusesCountAttrStr: NSAttributedString?
    var followersCountAttrStr: NSAttributedString?
    var followCountAttrStr: NSAttributedString?
    var following: Bool = false
    var followMe: Bool = false

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
        videosTabViewModel.viewController.config(withUserId: userId)
        photosTabViewModel.viewController.config(withUserId: userId)
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
        if let screenName = user.screenName {
            let image = user.gender == "m" ? UIImage(named: "Male_Normal") : UIImage(named: "Female_Normal")
            let screenNameAttrStr = NSMutableAttributedString(string: screenName + " ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16)])
            let iconAttachment = NSTextAttachment()
            iconAttachment.image = image
            iconAttachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
            let iconAttrStr = NSAttributedString(attachment: iconAttachment)
            screenNameAttrStr.append(iconAttrStr)
            self.screenName = screenNameAttrStr
        }

        if let location = user.location {
            let image = UIImage(named: "Location_Normal")
            let locationAttrStr = NSMutableAttributedString(string: " " + location, attributes: [.font: UIFont.systemFont(ofSize: 15)])
            let iconAttachment = NSTextAttachment()
            iconAttachment.image = image
            iconAttachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
            let iconAttrStr = NSAttributedString(attachment: iconAttachment)
            locationAttrStr.insert(iconAttrStr, at: 0)
            self.location = locationAttrStr
        }

        statusesCountAttrStr = generateNumberAttrStr(count: user.statusesCount, type: "微博")
        followersCountAttrStr = generateNumberAttrStr(count: user.followersCount, type: "粉丝")
        followCountAttrStr = generateNumberAttrStr(count: user.followCount, type: "正在关注")

        isSelf = id == AccountManager.shared.user?.id

        following = user.following
        followMe = user.followMe
    }

    func generateNumberAttrStr(count: Int?, type: String) -> NSAttributedString {
        if let count = count {
            let countAttrStr = NSAttributedString(string: String(format: "%d", count), attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
            let attrStr = NSMutableAttributedString(string: " " + type, attributes: [.font: UIFont.systemFont(ofSize: 15)])
            attrStr.insert(countAttrStr, at: 0)
            return attrStr
        } else {
            return NSAttributedString(string: "---", attributes: [.font: UIFont.systemFont(ofSize: 15)])
        }
    }
}
