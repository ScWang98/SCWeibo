//
//  StatusListViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import MJRefresh
import UIKit

class StatusListViewController: UIViewController {
    var tableView = UITableView()

    var listViewModel = StatusListViewModel()

    var isPull: Bool = false

    deinit {
        removeObservers()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        addObservers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

// MARK: - Public Methods

extension StatusListViewController {
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
        listViewModel.registerCells(with: tableView)
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
            self.isPull = false
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

        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier, for: indexPath)
        cell.selectionStyle = .none

        if let homeCell = (cell as? StatusCell) {
            homeCell.reload(with: viewModel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = listViewModel.statusList[indexPath.row]
        return viewModel.cellHeight
    }
}

// MARK: - Action

@objc private extension StatusListViewController {
}
