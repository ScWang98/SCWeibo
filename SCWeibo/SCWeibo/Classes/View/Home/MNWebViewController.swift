//
//  MNWebViewController.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/12.
//

import UIKit
import WebKit

class MNWebViewController: MNBaseViewController {

    private lazy var webView = WKWebView(frame: UIScreen.main.bounds)
    
    var urlString:String?{
        didSet{
            guard let urlString = urlString,
            let url = URL(string: urlString) else {
                return
            }
            webView.load(URLRequest(url: url))
        }
    }
    
    override func setupTableView() {
        self.title = "网页"
        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        view.insertSubview(webView, belowSubview: navigationBar)
        webView.scrollView.contentInset.top = MN_naviBarHeight
        webView.backgroundColor = UIColor.white
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
    }
}
