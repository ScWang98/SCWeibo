//
//  DetailCommentListViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit
import MJRefresh

class DetailCommentListViewController: UIViewController {
    var tableView = UITableView()

    private var listViewModel = DetailCommentListViewModel()

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
    func config(status: StatusResponse?) {
        listViewModel.config(status: status)
    }
    
    func refreshData(with loadingState: Bool) {
        loadDatas(loadMore: false)
    }
}

// MARK: - UI

private extension DetailCommentListViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        tableView.register(DetailCommentTableCell.self, forCellReuseIdentifier: String(describing: DetailCommentTableCell.self))
        tableView.frame = view.bounds
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadDatas(loadMore: true)
        })
        view.addSubview(tableView)
    }
}

// MARK: - Private Methods

private extension DetailCommentListViewController {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = listViewModel.commentList[indexPath.row]

        let referenceModel = WriteReferenceModel()
        referenceModel.status = listViewModel.status
        referenceModel.comment = viewModel.model

        let userInfo: [String : Any] = ["writeType": WriteType.commentComment, "referenceModel": referenceModel]
        Router.open(url: "pillar://writeStatus", userInfo: userInfo)
    }
}

// MARK: - Action

@objc private extension DetailCommentListViewController {
}
