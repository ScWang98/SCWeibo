//
//  StatusDetailRepostTabViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class StatusDetailRepostTabViewModel {
    let viewController = DetailRepostListViewController()
    var repostNumber: Int = 0
}

extension StatusDetailRepostTabViewModel: StatusDetailTabViewModel {
    var tabName: String {
        return String(format: "转发: %d", repostNumber)
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
