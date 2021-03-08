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

// MARK: - UI

extension StatusListViewController {
    func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .none
        listViewModel.registerCells(with: tableView)
        tableView.mj_header = MJRefreshHeader(refreshingTarget: self, refreshingAction: #selector(loadDatas))
        tableView.mj_footer = MJRefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadDatas))
        tableView.frame = view.bounds
        view.addSubview(tableView)

        tableView.mj_header?.beginRefreshing()
    }
}

// MARK: - Private Methods

private extension StatusListViewController {
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(tapBrowerPhoto(noti:)), name: NSNotification.Name(rawValue: MNWeiboCellBrowserPhotoNotification), object: nil)
    }

    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
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

extension StatusListViewController: MNHomeCellDelegate {
    func homeCellDidClickUrlString(cell: MNHomeBaseCell, urlStr: String) {
        print("urlStr = \(urlStr)")
        let vc = MNWebViewController()
        vc.urlString = urlStr
        vc.title = "123"
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Action

@objc extension StatusListViewController {
    private func tapBrowerPhoto(noti: Notification) {
        let userInfo = noti.userInfo
        guard let selectedIndex = userInfo?[MNWeiboCellBrowserPhotoIndexKey] as? Int,
            let imageViews = userInfo?[MNWeiboCellBrowserPhotoImageViewsKeys] as? [UIImageView],
            let urls = userInfo?[MNWeiboCellBrowserPhotoURLsKeys] as? [String] else {
            return
        }

        let vc = HMPhotoBrowserController.photoBrowser(withSelectedIndex: selectedIndex, urls: urls, parentImageViews: imageViews)
        present(vc, animated: true, completion: nil)
    }

    func loadDatas() {
        listViewModel.loadStatus(pullup: self.isPull) { _, needRefresh in
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            self.isPull = false
            if needRefresh {
                self.tableView.reloadData()
            }
        }
    }
}
