//
//  UserProfileViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/1.
//

import Neon
import UIKit

class UserProfileViewController: UIViewController {
    let topToolBar = UserProfileTopToolBar()
    let headerView = UserProfileHeaderView()
    let categoryBar = HorizontalCategoryBar()
    let pagesView = PagesScrollView()

    var pageVCs = [StatusListViewController]()

    init() {
        super.init(nibName: nil, bundle: nil)

        pageVCs.append(StatusListViewController())
        pageVCs.append(StatusListViewController())
        pageVCs.append(StatusListViewController())
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

        var array = [HorizontalCategoryBarItem]()
        var item = HorizontalCategoryBarItem()
        item.name = "微博"
        array.append(item)
        item = HorizontalCategoryBarItem()
        item.name = "视频"
        array.append(item)
        item = HorizontalCategoryBarItem()
        item.name = "相册"
        array.append(item)
        categoryBar.reload(items: array)
    }

    func addObservers() {
        self.pagesView.bk_addObserver(forKeyPath: "contentOffset", options: [.new, .old]) { _, _ in
            self.categoryBar.bottom = max(self.topToolBar.bottom + self.headerView.height - self.pagesView.contentOffset.y, self.topToolBar.bottom + self.categoryBar.height)
        }
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
        return pageVCs.count
    }

    func pagesView(_ pagesView: PagesScrollView, pageViewControllerAt index: Int) -> UIViewController {
        return pageVCs[index]
    }

    func pagesView(_ pagesView: PagesScrollView, pageScrollViewAt index: Int) -> UIScrollView {
        pageVCs[index].tableView
    }
}

// MARK: - Action

@objc private extension UserProfileViewController {
    func settingButtonClickedAction(button: UIButton) {
    }
}
