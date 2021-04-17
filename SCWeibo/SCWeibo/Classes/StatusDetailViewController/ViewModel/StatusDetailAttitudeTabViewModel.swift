//
//  StatusDetailAttitudeTabViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class StatusDetailAttitudeTabViewModel {
    let viewController = DetailAttitudeListViewController()
    var attitudeNumber: Int = 0
}

extension StatusDetailAttitudeTabViewModel: StatusDetailTabViewModel {
    var tabName: String {
        return String(format: "点赞: %d", attitudeNumber)
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
