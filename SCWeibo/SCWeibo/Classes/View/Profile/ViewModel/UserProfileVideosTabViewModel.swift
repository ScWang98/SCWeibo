//
//  UserProfileVideosTabViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/19.
//

import Foundation

class UserProfileVideosTabViewModel {
    let viewController = VideosListViewController()
    
}

extension UserProfileVideosTabViewModel: UserProfileTabViewModel {
    var tabName: String {
        return "视频"
    }
    
    var tabViewController: UIViewController? {
        return viewController
    }
    
    var tabView: UIView {
        return viewController.view
    }
    
    var tabScrollView: UIScrollView {
        return viewController.tableView
    }
    
    func tabRefresh(with completion: (() -> Void)?) {
        viewController.refreshData(with: false)
    }
}
