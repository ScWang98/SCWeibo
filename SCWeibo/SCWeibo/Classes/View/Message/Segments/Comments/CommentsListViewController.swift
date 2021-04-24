//
//  CommentsListViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import MJRefresh
import UIKit

class CommentsListViewController: UIViewController {
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

extension CommentsListViewController {
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

private extension CommentsListViewController {
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

private extension CommentsListViewController {
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

extension CommentsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.statusList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.statusList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatusRepostCell.self), for: indexPath)
        cell.selectionStyle = .none

        if let homeCell = (cell as? StatusRepostCell) {
            homeCell.reload(with: viewModel)
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

// MARK: - Action

@objc private extension CommentsListViewController {
}

