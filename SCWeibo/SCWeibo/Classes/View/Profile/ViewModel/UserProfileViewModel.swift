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
    var tabViewModels = [UserProfileTabViewModel]()
    
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
    
    init() {
        
        tabViewModels.append(UserProfileStatusTabViewModel.init())
        tabViewModels.append(UserProfileVideosTabViewModel.init())
        tabViewModels.append(UserProfilePhotosTabViewModel.init())
    }
    
    func fetchUserInfo(completion:@escaping ()->Void) {
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
        self.id = user.id
        self.screenName = user.screenName
        if let urlString = user.avatar {
            self.avatar = URL(string: urlString)
        } else {
            self.avatar = nil
        }
        if let urlString = user.avatar {
            self.avatarHD = URL(string: urlString)
        } else {
            self.avatarHD = nil
        }
        if let description = user.description,
           description.count > 0 {
            self.description = description
        } else  {
            description = "你还没有描述"
        }
        self.genderImage = user.gender == "m" ? UIImage(named: "Male_Normal") : UIImage(named: "Female_Normal")
        if let statusesCount = user.statusesCount {
            self.statusesCountStr = String(format: "%d 微博", statusesCount)
        } else {
            self.statusesCountStr = "---"
        }
        if let followersCount = user.followersCount {
            self.followersCountStr = String(format: "%d 粉丝", followersCount)
        } else {
            self.followersCountStr = "---"
        }
        if let followCount = user.followCount {
            self.followCountStr = String(format: "%d 正在关注", followCount)
        } else {
            self.followCountStr = "---"
        }
    }
}
