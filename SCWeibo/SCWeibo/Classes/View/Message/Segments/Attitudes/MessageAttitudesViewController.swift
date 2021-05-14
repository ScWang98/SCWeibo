//
//  MessageAttitudesViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import UIKit
import MJRefresh

class MessageAttitudesViewController: UIViewController {
    var tableView = UITableView()

    private var listViewModel = MessageAttitudesViewModel()

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
        self.refreshData(loadingState: false)
    }
}

// MARK: - Public Methods

extension MessageAttitudesViewController {
    func refreshData(loadingState: Bool) {
        loadDatas(loadMore: false)
    }
}

// MARK: - UI

private extension MessageAttitudesViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        tableView.register(MessageAttitudeCell.self, forCellReuseIdentifier: String(describing: MessageAttitudeCell.self))
        tableView.frame = view.bounds
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.loadDatas(loadMore: false)
        })
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadDatas(loadMore: true)
        })
        view.addSubview(tableView)
    }
}

// MARK: - Private Methods

private extension MessageAttitudesViewController {
    func addObservers() {
    }

    func removeObservers() {
    }

    func loadDatas(loadMore: Bool) {
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

extension MessageAttitudesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.attitudeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.attitudeList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageAttitudeCell.self), for: indexPath)
        cell.selectionStyle = .none

        if let cell = cell as? MessageAttitudeCell {
            cell.reload(with: viewModel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = listViewModel.attitudeList[indexPath.row]
        return viewModel.cellHeight(cellWidth: tableView.width)
    }
}

// MARK: - Action

@objc private extension MessageAttitudesViewController {
}
