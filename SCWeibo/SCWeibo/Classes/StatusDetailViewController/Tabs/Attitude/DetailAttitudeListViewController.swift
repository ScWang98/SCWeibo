//
//  DetailAttitudeListViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class DetailAttitudeListViewController: UIViewController {
    var tableView = UITableView()

    private var listViewModel = DetailAttitudeListViewModel()

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

extension DetailAttitudeListViewController {
    func config(statusId: String?) {
        listViewModel.config(statusId: statusId)
    }
    
    func refreshData(with loadingState: Bool) {
        loadDatas()
    }
}

// MARK: - UI

private extension DetailAttitudeListViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        tableView.register(DetailAttitudeTableCell.self, forCellReuseIdentifier: String(describing: DetailAttitudeTableCell.self))
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }
}

// MARK: - Private Methods

private extension DetailAttitudeListViewController {
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

extension DetailAttitudeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.attitudeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = listViewModel.attitudeList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailAttitudeTableCell.self), for: indexPath)
        cell.selectionStyle = .none

        if let cell = cell as? DetailAttitudeTableCell {
            cell.reload(with: viewModel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Action

@objc private extension DetailAttitudeListViewController {

}


