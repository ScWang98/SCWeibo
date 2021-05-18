//
//  ProfileFollowViewController.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/17.
//

import MJRefresh
import UIKit

enum ProfileFollowType {
    case following
    case follower
}

class ProfileFollowViewController: UITableViewController {
    private var listViewModel: ProfileFollowViewModel
    private var totalCount: Int
    private var followType: ProfileFollowType

    init(type: ProfileFollowType, userId: Int, count: Int) {
        listViewModel = ProfileFollowViewModel(type: type, userId: userId)
        followType = type
        totalCount = count
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        loadDatas(loadMore: false)
        
        let prefix = followType == .following ? "关注" : "粉丝"
        navigationItem.title = prefix + "（" + String(totalCount) + "）"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - UI

private extension ProfileFollowViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        tableView.register(ProfileFollowUserCell.self, forCellReuseIdentifier: String(describing: ProfileFollowUserCell.self))
        tableView.frame = view.bounds
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadDatas(loadMore: true)
        })
    }
}

// MARK: - Private Methods

private extension ProfileFollowViewController {
    func loadDatas(loadMore: Bool) {
        listViewModel.loadStatus(loadMore: loadMore) { _, needRefresh in
            self.tableView.mj_footer?.endRefreshing()
            if needRefresh {
                self.tableView.reloadData()
            }
            if !loadMore && self.listViewModel.usersList.count < 3 {
                self.loadDatas(loadMore: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfileFollowViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.usersList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.usersList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileFollowUserCell.self), for: indexPath)
        cell.selectionStyle = .none

        if let cell = cell as? ProfileFollowUserCell {
            cell.reload(with: viewModel)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = listViewModel.usersList[indexPath.row]
        return viewModel.cellHeight(cellWidth: tableView.width)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = listViewModel.usersList[indexPath.row]
        
        let userInfo = ["user": viewModel.user]
        Router.open(url: "pillar://userProfile", userInfo: userInfo)
    }
}
