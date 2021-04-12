//
//  DetailCommentListViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class DetailCommentListViewController: UIViewController {
    var tableView = UITableView()

    private var listViewModel = VideosListViewModel()

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

extension DetailCommentListViewController {
    func refreshData(with loadingState: Bool) {
//        loadDatas()
    }
}

// MARK: - UI

private extension DetailCommentListViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        tableView.register(VideoTableCell.self, forCellReuseIdentifier: String(describing: VideoTableCell.self))
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

// MARK: - Private Methods

private extension DetailCommentListViewController {
    func addObservers() {
    }

    func removeObservers() {
    }
    
    func loadDatas() {
        listViewModel.loadStatus(loadMore: isPull) { _, needRefresh in
            self.isPull = false
            if needRefresh {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension DetailCommentListViewController: UITableViewDelegate, UITableViewDataSource {
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

@objc private extension DetailCommentListViewController {

}

