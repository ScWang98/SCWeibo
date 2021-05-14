//
//  WebViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/22.
//

import UIKit
import WebKit
import SafariServices

class WebViewController: UIViewController, RouteAble {
    var webView = WKWebView()

    var url: String?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init(routeParams: Dictionary<AnyHashable, Any>) {
        self.init()

        if let userInfo: [AnyHashable: Any] = routeParams.sc.dictionary(for: RouterParameterUserInfo) {
            url = userInfo.sc.string(for: "url")
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

// MARK: - Private Methods

private extension WebViewController {
    func setupSubviews() {
        navigationController?.navigationBar.isHidden = false

        view.addSubview(webView)

        webView.fillSuperview(top: view.safeAreaInsets.top)

        if let urlString = url {
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
