//
//  StatusListViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import MJRefresh
import SwipeCellKit
import UIKit

class StatusListViewController: UIViewController {
    var tableView = UITableView()

    var listViewModel = StatusListViewModel()

    deinit {
        removeObservers()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        addObservers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

// MARK: - Public Methods

extension StatusListViewController {
    func config(withUserId userId: String?) {
        listViewModel.config(withUserId: userId)
    }

    func refreshData(with loadingState: Bool) {
        if loadingState {
            tableView.mj_header?.beginRefreshing()
        } else {
            loadDatas(with: false)
        }
    }
}

// MARK: - UI

private extension StatusListViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        tableView.register(StatusRepostCell.self, forCellReuseIdentifier: String(describing: StatusRepostCell.self))
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadDatas(with: false)
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadDatas(with: true)
        })
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

// MARK: - Private Methods

private extension StatusListViewController {
    func addObservers() {
    }

    func removeObservers() {
    }

    func loadDatas(with loadMore: Bool) {
        listViewModel.loadStatus(loadMore: loadMore) { _, needRefresh in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            if needRefresh {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StatusListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.statusList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatusRepostCell.self), for: indexPath)
        cell.selectionStyle = .none

        if let homeCell = (cell as? StatusRepostCell) {
            homeCell.reload(with: viewModel)
            homeCell.delegate = self
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = listViewModel.statusList[indexPath.row]
        return viewModel.cellHeight(width: tableView.width)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let status = listViewModel.statusList[indexPath.row].status
        let userInfo = ["status": status]

        Router.open(url: "pillar://statusDetail", userInfo: userInfo)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StatusListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let viewModel = listViewModel.statusList[indexPath.row]
        if orientation == .right {
            var swipeActions = [SwipeAction]()

            let favorite = SwipeAction(style: .default, title: "收藏") { _, _ in
                viewModel.sendFavoriteAction()
            }
            favorite.backgroundColor = UIColor.sc.color(RGB: 0xD0D0D5)
            favorite.hidesWhenSelected = true
            swipeActions.append(favorite)

            let comment = SwipeAction(style: .default, title: "评论") { _, _ in
                viewModel.sendCommentAction()
            }
            comment.backgroundColor = UIColor.sc.color(RGB: 0xB7B7BC)
            comment.hidesWhenSelected = true
            swipeActions.append(comment)

            let repost = SwipeAction(style: .default, title: "转发") { _, _ in
                viewModel.sendRepostAction()
            }
            repost.backgroundColor = UIColor.sc.color(RGB: 0x9F9FA4)
            repost.hidesWhenSelected = true
            swipeActions.append(repost)

            if viewModel.status.user?.id == AccountManager.shared.user?.id {
                let delete = SwipeAction(style: .default, title: "删除") { _, _ in
                    viewModel.sendDeleteAction { _ in
                        self.tableView.performBatchUpdates {
                            self.listViewModel.statusList.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        } completion: { _ in
                            self.tableView.reloadData()
                        }
                    }
                }
                delete.backgroundColor = UIColor.sc.color(RGB: 0xFF3B30)
                delete.hidesWhenSelected = true
                swipeActions.append(delete)
            }

            return swipeActions
        }
        return nil
    }
}

// MARK: - Action

@objc private extension StatusListViewController {
}
