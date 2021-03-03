//
//  UserProfileViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/1.
//

import UIKit

class UserProfileViewController: UIViewController {
    let topToolBar = UserProfileTopToolBar()
    let headerView = UserProfileHeaderView()
    let categoryBar = HorizontalCategoryBar()
    let pagesView = PagesScrollView()

    var pageVCs = [MNHomeViewController]()

    init() {
        super.init(nibName: nil, bundle: nil)

        pageVCs.append(MNHomeViewController())
        pageVCs.append(MNHomeViewController())
        pageVCs.append(MNHomeViewController())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagesView.reloadPages()
    }
}

// MARK: - UI

private extension UserProfileViewController {
    func setupSubviews() {
        view.backgroundColor = UIColor.white

        topToolBar.delegate = self

        categoryBar.backgroundColor = UIColor.white
        categoryBar.delegate = self

        headerView.frame = CGRect(x: 0, y: 0, width: view.width, height: 100)
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
        pagesView.set(currentIndex: index, animated: true)
    }
}

// MARK: - PagesScrollViewDataSource

extension UserProfileViewController: PagesScrollViewDataSource, PagesScrollViewDelegate {
    // MARK: PagesScrollViewDelegate

    func pagesView(_ pagesView: PagesScrollView, dragToSelectPageAt index: Int) {
        categoryBar.selectItem(at: index)
    }

    // MARK: PagesScrollViewDataSource

    func numberOfPages(in pagesView: PagesScrollView) -> Int {
        3
    }

    func pagesView(_ pagesView: PagesScrollView, pageViewControllerAt index: Int) -> UIViewController {
        return pageVCs[index]
    }

    func pagesView(_ pagesView: PagesScrollView, pageScrollViewAt index: Int) -> UIScrollView {
        pageVCs[index].tableView!
    }
}

// MARK: - Action

@objc private extension UserProfileViewController {
    func settingButtonClickedAction(button: UIButton) {
    }
}
