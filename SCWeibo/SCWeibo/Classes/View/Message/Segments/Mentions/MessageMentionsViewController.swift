//
//  MessageMentionsViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import UIKit

class MessageMentionsViewController: StatusListViewController {
    let avatarView = NavigationAvatarView()
    let titleButton = HomeTitleButton()
    
    let service = MessageMentionsService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        self.refreshData(with: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - UI

private extension MessageMentionsViewController {
    func setupSubviews() {
        listViewModel.listService = service
    }
}
