//
//  VideosListViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/17.
//

import UIKit

class VideosListViewController: UIViewController {
    var tableView = UITableView()

    private var listViewModel = StatusListViewModel()

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

extension VideosListViewController {
    func refreshData(with loadingState: Bool) {
        self.loadDatas()
    }
}

// MARK: - UI

private extension VideosListViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        listViewModel.registerCells(with: tableView)
        tableView.frame = view.bounds
        view.addSubview(tableView)

        self.loadDatas()
    }
}

// MARK: - Private Methods

private extension VideosListViewController {
    func addObservers() {
    }

    func removeObservers() {
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension VideosListViewController: UITableViewDelegate, UITableViewDataSource {
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

@objc private extension VideosListViewController {
    func loadDatas() {
        listViewModel.loadStatus(pullup: self.isPull) { _, needRefresh in
            self.isPull = false
            if needRefresh {
                self.tableView.reloadData()
            }
        }
    }
}
