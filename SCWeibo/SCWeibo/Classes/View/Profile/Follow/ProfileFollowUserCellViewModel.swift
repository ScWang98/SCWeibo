//
//  ProfileFollowUserCellViewModel.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/17.
//

import UIKit

enum UserFollowState {
    case unFollowing
    case following
    case mutualFollowing
}

class ProfileFollowUserCellViewModel {
    var user: UserResponse
    var avatarUrl: String?
    var screenName: String?
    var description: String?
    var followState: UserFollowState {
        if user.following && user.followMe {
            return .mutualFollowing
        } else if user.following {
            return .following
        } else {
            return .unFollowing
        }
    }

    init(with model: UserResponse) {
        self.user = model
        parseProperties()
    }
}

// MARK: - Public Methods

extension ProfileFollowUserCellViewModel {
    func cellHeight(cellWidth: CGFloat) -> CGFloat {
        return 74
    }
    
    func sendFollowAction(follow: Bool, refresh: (() -> Void)? = nil) {
        guard let userId = user.id else {
            return
        }
        
        if follow {
            UserCommonActionManager.sendFollowAction(follow: follow, userId: userId) { (success) in
                refresh?()
            }
        } else {
            var title = "您确定要取消关注"
            if let screenName = screenName {
                title = title + "「" + screenName + "」？"
            } else {
                title = title + "此用户吗？"
            }
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "取消关注", style: .destructive, handler: { _ in
                refresh?()
                UserCommonActionManager.sendFollowAction(follow: follow, userId: userId) { (success) in
                    refresh?()
                }
            }))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            ResponderHelper.visibleTopViewController()?.present(alert, animated: true, completion: nil)
        }
    }
}

private extension ProfileFollowUserCellViewModel {
    func parseProperties() {
        avatarUrl = user.avatar
        screenName = user.screenName
        description = user.description
    }
}
