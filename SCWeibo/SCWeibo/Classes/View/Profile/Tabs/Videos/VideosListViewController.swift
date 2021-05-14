//
//  VideosListViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/17.
//

import UIKit
import MJRefresh

class VideosListViewController: UIViewController {
    var tableView = UITableView()

    private var listViewModel = VideosListViewModel()

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

extension VideosListViewController {
    func config(withUserId userId: String?) {
        listViewModel.config(withUserId: userId)
    }
    
    func refreshData(with loadingState: Bool) {
        loadDatas(loadMore: false)
    }
}

// MARK: - UI

private extension VideosListViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        tableView.register(VideoTableCell.self, forCellReuseIdentifier: String(describing: VideoTableCell.self))
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadDatas(loadMore: true)
        })
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

// MARK: - Private Methods

private extension VideosListViewController {
    func addObservers() {
    }

    func removeObservers() {
    }
    
    func loadDatas(loadMore: Bool) {
        listViewModel.loadStatus(loadMore: loadMore) { _, needRefresh in
            self.tableView.mj_footer?.endRefreshing()
            if needRefresh {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension VideosListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.videoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.videoList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VideoTableCell.self), for: indexPath)
        cell.selectionStyle = .none

        if let cell = cell as? VideoTableCell {
            cell.reload(with: viewModel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let coverHeight = view.width * 9.0 / 16.0
        let height = 12.0 + coverHeight + 25.0 * 2 + 8.0
        return height
    }
}

// MARK: - Action

@objc private extension VideosListViewController {

}
