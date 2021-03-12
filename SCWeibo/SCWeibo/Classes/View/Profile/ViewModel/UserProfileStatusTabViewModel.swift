//
//  UserProfileStatusTabViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/12.
//

import UIKit

class UserProfileStatusTabViewModel {
    let viewController = StatusListViewController()
    
}

extension UserProfileStatusTabViewModel: UserProfileTabViewModel {
    var tabName: String {
        return "微博"
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
    
    func tabRefresh(with completion: () -> Void) {
        viewController.refreshData(with: false)
    }
}
