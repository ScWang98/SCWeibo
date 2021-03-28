//
//  UserProfileViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/1.
//

import FLEX
import Neon
import UIKit

class UserProfileViewController: UIViewController {
    let topToolBar = UserProfileTopToolBar()
    let headerView = UserProfileHeaderView()
    let categoryBar = HorizontalCategoryBar()
    let pagesView = PagesScrollView()

    let viewModel = UserProfileViewModel()

    var pagesObservation: NSKeyValueObservation?
    
    deinit {
        pagesObservation?.invalidate()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        addObservers()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagesView.reloadPages()
        pagesView.set(selectedIndex: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.fetchUserInfo {
            self.refresh()
        }
    }
}

// MARK: - Private Methods

private extension UserProfileViewController {
    func setupSubviews() {
        view.backgroundColor = UIColor.white

        topToolBar.delegate = self

        categoryBar.backgroundColor = UIColor.white
        categoryBar.delegate = self

        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 240)
        pagesView.headerView = headerView
        pagesView.pagesDataSource = self
        pagesView.pagesDelegate = self

        view.addSubview(topToolBar)
        view.addSubview(pagesView)
        view.addSubview(categoryBar)

        let safeArea = UIApplication.shared.sc.keyWindow?.safeAreaInsets
        topToolBar.anchorToEdge(.top, padding: 0, width: view.width, height: (safeArea?.top ?? 0) + 44)
        pagesView.frame = CGRect(x: 0, y: topToolBar.yMax, width: view.width, height: view.height - topToolBar.height)
        categoryBar.align(.underCentered, relativeTo: headerView, padding: 10, width: view.width, height: 50)

        categoryBar.reload(names: viewModel.tabNames)
    }

    func addObservers() {
        pagesObservation = self.pagesView.observe(\PagesScrollView.contentOffset, options: [.new, .old]) { _, _ in
            self.categoryBar.bottom = max(self.topToolBar.bottom + self.headerView.height - self.pagesView.contentOffset.y, self.topToolBar.bottom + self.categoryBar.height)
        }
    }
    
    func refresh() {
        self.headerView.reload(with: self.viewModel)
    }
}

// MARK: - UserProfileTopToolBarDelegate

extension UserProfileViewController: UserProfileTopToolBarDelegate {
    func topToolBarDidClickBack(_ topToolBar: UserProfileTopToolBar) {
        if let viewControllers = self.navigationController?.viewControllers, viewControllers.count > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func topToolBarDidClickSetting(_ topToolBar: UserProfileTopToolBar) {
        if FLEXManager.shared.isHidden {
            FLEXManager.shared.showExplorer()
        } else {
            FLEXManager.shared.hideExplorer()
        }
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
    func settingButtonClickedAction(button: UIButton) {
    }
}
