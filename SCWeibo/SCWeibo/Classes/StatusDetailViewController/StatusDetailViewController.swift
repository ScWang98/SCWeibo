//
//  StatusDetailViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/23.
//

import UIKit

class StatusDetailViewController: UIViewController, RouteAble {
    let detailContentView = StatusDetailContentView()
    let categoryBar = StatusDetailHorizontalCategoryBar()
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
        categoryBar.selectItem(at: 1, animated: false)
        pagesView.reloadPages()
        pagesView.set(selectedIndex: 1, animated: false)
        
        viewModel.reloadAllTabsContent()
        
        let rightButton = UIBarButtonItem.init(image: UIImage(named: "MoreActionButton_Normal"), style: .plain, target: self, action: #selector(moreButtonDidClicked(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
        self.title = "微博正文"
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
}

// MARK: - Private Methods

private extension StatusDetailViewController {
    func commonInit() {
        addObservers()
    }

    func setupSubviews() {
        view.backgroundColor = UIColor.white

        categoryBar.delegate = self

        detailContentView.frame = CGRect(x: 0, y: 0, width: view.width, height: 240)
        pagesView.headerView = detailContentView
        pagesView.pagesDataSource = self
        pagesView.pagesDelegate = self

        view.addSubview(pagesView)
        view.addSubview(categoryBar)

        pagesView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        categoryBar.align(.underCentered, relativeTo: detailContentView, padding: 10, width: view.width, height: 35)
        self.view.setNeedsLayout()
    }

    func addObservers() {
        pagesObservation = pagesView.observe(\PagesScrollView.contentOffset, options: [.new, .old]) { _, _ in
            self.categoryBar.bottom = max(self.detailContentView.height - self.pagesView.contentOffset.y, self.categoryBar.height)
        }
    }
    
    func removeObservers() {
        pagesObservation?.invalidate()
    }

    func refreshHeader() {
        detailContentView.reload(with: viewModel)
    }
}

// MARK: - StatusDetailHorizontalCategoryDelegate

extension StatusDetailViewController: StatusDetailHorizontalCategoryBarDelegate {
    func categoryBar(_ categoryBar: StatusDetailHorizontalCategoryBar, didSelectItemAt index: Int) {
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
    
    func moreButtonDidClicked(sender: Any) {
        
    }
}

