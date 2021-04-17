//
//  StatusDetailCommentTabViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class StatusDetailCommentTabViewModel {
    let viewController = DetailCommentListViewController()
    var commentNumber: Int = 0
}

extension StatusDetailCommentTabViewModel: StatusDetailTabViewModel {
    var tabName: String {
        return String(format: "评论: %d", commentNumber)
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
