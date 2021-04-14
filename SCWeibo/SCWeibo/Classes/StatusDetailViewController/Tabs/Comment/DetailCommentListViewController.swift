//
//  DetailCommentListViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class DetailCommentListViewController: UIViewController {
    var tableView = UITableView()

    private var listViewModel = DetailCommentListViewModel()

    var isPull: Bool = false

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

extension DetailCommentListViewController {
    func refreshData(with loadingState: Bool) {
        loadDatas()
    }
}

// MARK: - UI

private extension DetailCommentListViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.sc.color(RGBA: 0xC7C7CCFF)
        tableView.register(DetailCommentTableCell.self, forCellReuseIdentifier: String(describing: DetailCommentTableCell.self))
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
        return listViewModel.commentList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.commentList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailCommentTableCell.self), for: indexPath)
        cell.selectionStyle = .none

        if let cell = cell as? DetailCommentTableCell {
            cell.reload(with: viewModel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = listViewModel.commentList[indexPath.row]
        return viewModel.cellHeight(cellWidth: tableView.width)
    }
}

// MARK: - Action

@objc private extension DetailCommentListViewController {
}
