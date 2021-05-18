//
//  MessageCommentsViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import MJRefresh
import UIKit

enum MessageCommentsListType {
    case received
    case mentioned
    case sended
}

class MessageCommentsViewController: UIViewController {
    let tableView = UITableView()

    private var listViewModel: MessageCommentsViewModel

    deinit {
        removeObservers()
    }
    
    init(type: MessageCommentsListType) {
        listViewModel = MessageCommentsViewModel(type: type)
        super.init(nibName: nil, bundle: nil)
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        refreshData(loadingState: false)
    }
}

// MARK: - Public Methods

extension MessageCommentsViewController {
    func refreshData(loadingState: Bool) {
        loadDatas(loadMore: false)
    }
}

// MARK: - UI

private extension MessageCommentsViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        tableView.register(MessageCommentCell.self, forCellReuseIdentifier: String(describing: MessageCommentCell.self))
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

private extension MessageCommentsViewController {
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
            if !loadMore && self.listViewModel.commentsList.count < 3 {
                self.loadDatas(loadMore: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MessageCommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.commentsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.commentsList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageCommentCell.self), for: indexPath)
        cell.selectionStyle = .none

        if let cell = cell as? MessageCommentCell {
            cell.reload(with: viewModel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = listViewModel.commentsList[indexPath.row]
        return viewModel.cellHeight(cellWidth: tableView.width)
    }
}

// MARK: - Action

@objc private extension MessageCommentsViewController {
}
