//
//  UserProfileViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/1.
//

import FLEX
import Neon
import UIKit

class UserProfileViewController: UIViewController, RouteAble {
    let headerView = UserProfileHeaderView()
    let categoryBar = HorizontalCategoryBar()
    let pagesView = PagesScrollView()

    let viewModel: UserProfileViewModel

    var pagesObservation: NSKeyValueObservation?

    deinit {
        removeObservers()
    }

    init() {
        viewModel = UserProfileViewModel(with: nil)

        super.init(nibName: nil, bundle: nil)

        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(routeParams: Dictionary<AnyHashable, Any>) {
        viewModel = UserProfileViewModel(with: routeParams)

        super.init(nibName: nil, bundle: nil)

        commonInit()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupSubviews()
        refreshHeader()
        
        categoryBar.reload(names: viewModel.tabNames)
        pagesView.reloadPages()
        
        viewModel.reloadAllTabsContent()
        
        var rightItems = [UIBarButtonItem]()
        let queryButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(queryButtonDidClicked(sender:)))
        rightItems.append(queryButton)
        if (viewModel.isSelf) {
            let settingButton = UIBarButtonItem(title: "设置", target: self, action: #selector(settingButtonDidClicked(sender:)))
            rightItems.append(settingButton)
        }
        navigationItem.rightBarButtonItems = rightItems
        navigationItem.title = "个人资料"
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.fetchUserInfo {
            self.refreshHeader()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        setupLayout()
    }
}

// MARK: - Private Methods

private extension UserProfileViewController {
    func commonInit() {
        addObservers()
    }

    func setupSubviews() {
        view.backgroundColor = UIColor.white


        categoryBar.backgroundColor = UIColor.white
        categoryBar.delegate = self

        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 240)
        pagesView.headerView = headerView
        pagesView.pagesDataSource = self
        pagesView.pagesDelegate = self

        view.addSubview(pagesView)
        view.addSubview(categoryBar)
        
        setupLayout()
    }
    
    func setupLayout() {
        pagesView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height - view.safeAreaInsets.top)
        categoryBar.align(.underCentered, relativeTo: headerView, padding: 10, width: view.width, height: 50)
        self.view.setNeedsLayout()
    }

    func addObservers() {
        pagesObservation = pagesView.observe(\PagesScrollView.contentOffset, options: [.new, .old]) { _, _ in
            self.categoryBar.bottom = max(self.view.safeAreaInsets.top + self.headerView.height - self.pagesView.contentOffset.y, self.view.safeAreaInsets.top + self.categoryBar.height)
        }
    }
    
    func removeObservers() {
        pagesObservation?.invalidate()
    }

    func refreshHeader() {
        headerView.reload(with: viewModel)
    }
}

// MARK: - HorizontalCategoryDelegate

extension UserProfileViewController: HorizontalCategoryBarDelegate {
    func categoryBar(_ categoryBar: HorizontalCategoryBar, didSelectItemAt index: Int) {
        pagesView.set(selectedIndex: index, animated: true)
    }
}

// MARK: - PagesScrollViewDelegate / PagesScrollViewDataSource

extension UserProfileViewController: PagesScrollViewDataSource, PagesScrollViewDelegate {
    // MARK: PagesScrollViewDelegate

    func pagesView(_ pagesView: PagesScrollView, dragToSelectPageAt index: Int) {
        return categoryBar.selectItem(at: index)
    }

    func pagesView(_ pagesView: PagesScrollView, pagingFromIndex fromIndex: Int, toIndex: Int, percent: Double) {
        categoryBar.scrollSelected(fromIndex: fromIndex, toIndex: toIndex, percent: percent)
    }

    // MARK: PagesScrollViewDataSource

    func numberOfPages(in pagesView: PagesScrollView) -> Int {
        return viewModel.tabViewModels.count
    }

    func pagesView(_ pagesView: PagesScrollView, pageViewControllerAt index: Int) -> UIViewController? {
        return viewModel.tabViewModels[index].tabViewController
    }

    func pagesView(_ pagesView: PagesScrollView, pageViewAt index: Int) -> UIView {
        return viewModel.tabViewModels[index].tabView
    }

    func pagesView(_ pagesView: PagesScrollView, pageScrollViewAt index: Int) -> UIScrollView {
        return viewModel.tabViewModels[index].tabScrollView
    }
}

// MARK: - Action

@objc private extension UserProfileViewController {
    func queryButtonDidClicked(sender: Any) {
        
    }
    
    func settingButtonDidClicked(sender: Any) {
        if FLEXManager.shared.isHidden {
            FLEXManager.shared.showExplorer()
        } else {
            FLEXManager.shared.hideExplorer()
        }
    }
}
