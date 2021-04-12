//
//  StatusDetailAttitudeTabViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class StatusDetailAttitudeTabViewModel {
    let viewController = DetailAttitudeListViewController()
}

extension StatusDetailAttitudeTabViewModel: StatusDetailTabViewModel {
    var tabName: String {
        return "点赞"
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
