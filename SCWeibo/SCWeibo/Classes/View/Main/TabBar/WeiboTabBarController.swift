//
//  WeiboTabBarController.swift
//  SCWeibo
//
//  Created by scwang on 2020/3/10.
//

import UIKit

class WeiboTabBarController: UITabBarController {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupChildrenControllers()
        tabBar.tintColor = UIColor.sc.color(RGB: 0x0099FF)
        delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(userLogin(noti:)), name: NSNotification.Name(MNUserShouldLoginNotification), object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = tabBar.frame // self.TabBar is IBOutlet of your TabBar
        tabFrame.size.height -= 12
        tabFrame.origin.y += 12
        tabBar.frame = tabFrame
    }

    @objc func userLogin(noti: Notification) {
        var when = DispatchTime.now()

        if noti.object != nil {
            // FIXME: Need toast
            print("用户登录超时，请重新登陆")
            when = DispatchTime.now() + 2
        }

        DispatchQueue.main.asyncAfter(deadline: when) {
            self.showAuthorizeView()
        }
    }

    func showAuthorizeView() {
        let request: WBAuthorizeRequest = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        request.redirectURI = MNredirectUri
        request.scope = "all"
        request.shouldShowWebViewForAuthIfCannotSSO = true
        request.shouldOpenWeiboAppInstallPageIfNotInstalled = true

        WeiboSDK.send(request) { result in
            print("authorize result = \(result)")
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension WeiboTabBarController {
    private func setupChildrenControllers() {
        var array = [UIViewController]()
        for item in TabbarItemsManager.tabbarItems {
            if let viewController = item.viewController {
                array.append(viewController)
            }
        }

        viewControllers = array
    }
}

extension WeiboTabBarController: UITabBarControllerDelegate {
    /// will selected Tabbar Item
    /// - Parameters:
    ///   - tabBarController: tabBarController
    ///   - viewController: will switch to VC
    ///   - return: Whether to switch
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 当前控制器index
        let index = children.firstIndex(of: viewController)

        // 在首页，又点击了”首页“tabbar, ==> 滚动到顶部
        if selectedIndex == 0 && index == 0 {
//            let navi = children[0] as! UINavigationController
//            let vc = navi.children[0] as! MNBaseViewController

            // scroll to top
//            vc.tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

            // FIXME: dispatch work around.(必须滚动完,再刷新)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                vc.loadDatas()
//            }

            // clear badgeNumber
//            vc.tabBarItem.badgeValue = nil
//            UIApplication.shared.applicationIconBadgeNumber = 0
        }

        return !viewController.isMember(of: UIViewController.self)
    }
}
