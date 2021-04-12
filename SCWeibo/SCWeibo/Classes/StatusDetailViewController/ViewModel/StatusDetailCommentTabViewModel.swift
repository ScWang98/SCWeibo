//
//  StatusDetailCommentTabViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class StatusDetailCommentTabViewModel {
    let viewController = DetailCommentListViewController()
}

extension StatusDetailCommentTabViewModel: StatusDetailTabViewModel {
    var tabName: String {
        return "评论"
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
