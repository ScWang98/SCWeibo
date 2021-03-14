//
//  StatusHomeViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/14.
//

import UIKit

class StatusHomeViewController: StatusListViewController {
    let topBar = StatusHomeTopBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

// MARK: - UI

private extension StatusHomeViewController {
    func setupSubviews() {
        view.addSubview(topBar)

        let height = (UIApplication.shared.sc.keyWindow?.safeAreaInsets.top ?? 0) + 50
        topBar.anchorToEdge(.top, padding: 0, width: view.width, height: height)

        var inset = tableView.contentInset
        inset.top = 50
        tableView.contentInset = inset

        tableView.mj_header?.tintColor = UIColor.black
    }
}
