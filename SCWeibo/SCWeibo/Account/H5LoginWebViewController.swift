//
//  H5LoginWebViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/21.
//

import UIKit
import WebKit
import Alamofire

class H5LoginWebViewController: UIViewController, RouteAble {
    var webView = WKWebView()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init(routeParams: Dictionary<AnyHashable, Any>) {
        self.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        refreshLayout()
    }
}

// MARK: - Private Methods

private extension H5LoginWebViewController {
    func setupSubviews() {
        self.navigationController?.navigationBar.isHidden = false

        view.addSubview(webView)

        refreshLayout()

        webView.navigationDelegate = self

        guard let url = URL(string: "https://passport.weibo.cn/signin/login") else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func refreshLayout() {
        webView.fillSuperview(top: view.safeAreaInsets.top)
    }
}

extension H5LoginWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
        cookieStore.getAllCookies { cookies in
            print("wscccc---------------------")
            for cookie in cookies {
                HTTPCookieStorage.shared.setCookie(cookie)
                print("wscccc    " + cookie.domain + "\t\t\t" + cookie.name + " = " + cookie.value)
            }
            print("wscccc---------------------")
//            AF.sessionConfiguration.httpCookieStorage?.setCookies(<#T##cookies: [HTTPCookie]##[HTTPCookie]#>, for: <#T##URL?#>, mainDocumentURL: <#T##URL?#>)
//            let url = URL(string: "https://m.weibo.cn")
//            HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
        }

        decisionHandler(.allow)
    }
}
