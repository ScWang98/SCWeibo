//
//  DetailRepostListViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class DetailRepostListViewController: UIViewController {
    var tableView = UITableView()

    private var listViewModel = DetailRepostListViewModel()

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

extension DetailRepostListViewController {
    func refreshData(with loadingState: Bool) {
        loadDatas()
    }
}

// MARK: - UI

private extension DetailRepostListViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        tableView.register(DetailRepostTableCell.self, forCellReuseIdentifier: String(describing: DetailRepostTableCell.self))
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

// MARK: - Private Methods

private extension DetailRepostListViewController {
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

extension DetailRepostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.repostList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.repostList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailRepostTableCell.self), for: indexPath)
        cell.selectionStyle = .none

        if let cell = cell as? DetailRepostTableCell {
            cell.reload(with: viewModel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = listViewModel.repostList[indexPath.row]
        return viewModel.cellHeight
    }
}

// MARK: - Action

@objc private extension DetailRepostListViewController {

}

