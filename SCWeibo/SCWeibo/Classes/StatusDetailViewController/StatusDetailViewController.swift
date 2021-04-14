//
//  StatusDetailViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/23.
//

import UIKit

class StatusDetailViewController: UIViewController, RouteAble {
    let topToolBar = StatusDetailTopBar()
    let detailContentView = StatusDetailContentView()
    let categoryBar = HorizontalCategoryBar()
    let pagesView = PagesScrollView()

    let viewModel = StatusDetailViewModel()

    var pagesObservation: NSKeyValueObservation?

    deinit {
        removeObservers()
    }

    private init() {
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    required convenience init(routeParams: Dictionary<AnyHashable, Any>) {
        self.init()
        self.viewModel.config(with: routeParams)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupSubviews()
        refreshHeader()
        
        categoryBar.reload(names: viewModel.tabNames)
        pagesView.reloadPages()
        
        viewModel.reloadAllTabsContent()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.fetchUserInfo {
            self.refreshHeader()
        }
    }
}

// MARK: - Private Methods

private extension StatusDetailViewController {
    func commonInit() {
        addObservers()
    }

    func setupSubviews() {
        view.backgroundColor = UIColor.white

        topToolBar.delegate = self

        categoryBar.backgroundColor = UIColor.white
        categoryBar.delegate = self

        detailContentView.frame = CGRect(x: 0, y: 0, width: view.width, height: 240)
        pagesView.headerView = detailContentView
        pagesView.pagesDataSource = self
        pagesView.pagesDelegate = self

        view.addSubview(topToolBar)
        view.addSubview(pagesView)
        view.addSubview(categoryBar)

        let safeArea = UIApplication.shared.sc.keyWindow?.safeAreaInsets
        topToolBar.anchorToEdge(.top, padding: 0, width: view.width, height: (safeArea?.top ?? 0) + 44)
        pagesView.frame = CGRect(x: 0, y: topToolBar.yMax, width: view.width, height: view.height - topToolBar.height)
        categoryBar.align(.underCentered, relativeTo: detailContentView, padding: 10, width: view.width, height: 50)
        self.view.setNeedsLayout()
    }

    func addObservers() {
        pagesObservation = pagesView.observe(\PagesScrollView.contentOffset, options: [.new, .old]) { _, _ in
            self.categoryBar.bottom = max(self.topToolBar.bottom + self.detailContentView.height - self.pagesView.contentOffset.y, self.topToolBar.bottom + self.categoryBar.height)
        }
    }
    
    func removeObservers() {
        pagesObservation?.invalidate()
    }

    func refreshHeader() {
        detailContentView.reload(with: viewModel)
    }
}

// MARK: - UserProfileTopToolBarDelegate

extension StatusDetailViewController: StatusDetailTopBarDelegate {
    func topBarDidClickBack(_ topBar: StatusDetailTopBar) {
        if let viewControllers = self.navigationController?.viewControllers, viewControllers.count > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func topBarDidClickMore(_ topBar: StatusDetailTopBar) {
        
    }
}

// MARK: - HorizontalCategoryDelegate

extension StatusDetailViewController: HorizontalCategoryBarDelegate {
    func categoryBar(_ categoryBar: HorizontalCategoryBar, didSelectItemAt index: Int) {
        pagesView.set(selectedIndex: index, animated: true)
    }
}

// MARK: - PagesScrollViewDelegate / PagesScrollViewDataSource

extension StatusDetailViewController: PagesScrollViewDataSource, PagesScrollViewDelegate {
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

@objc private extension StatusDetailViewController {
    func settingButtonClickedAction(button: UIButton) {
    }
}

