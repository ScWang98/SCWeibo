//
//  H5LoginWebViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/21.
//

import UIKit
import WebKit

class H5LoginWebViewController: UIViewController, RouteAble {
    var webView = WKWebView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init(routeParams: Dictionary<AnyHashable, Any>) {
        self.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

// MARK: - Private Methods

private extension H5LoginWebViewController {
    func setupSubviews() {
        self.navigationController?.navigationBar.isHidden = false

        webView.frame = view.bounds

        view.addSubview(webView)

        webView.navigationDelegate = self

        guard let url = URL(string: "https://passport.weibo.cn/signin/login") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension H5LoginWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
        cookieStore.getAllCookies { cookies in
            for cookie in cookies {
                print("wscccccc   cookie")
                print(cookie)
            }
        }

        decisionHandler(.allow)
    }
}
