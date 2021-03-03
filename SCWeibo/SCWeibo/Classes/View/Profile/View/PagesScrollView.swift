//
//  PagesScrollView.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/3.
//

import UIKit

protocol PagesScrollViewDelegate: UIScrollViewDelegate {
    func pagesView(_ pagesView: PagesScrollView, dragToSelectPageAt index: Int)
}

protocol PagesScrollViewDataSource {
    func numberOfPages(in pagesView: PagesScrollView) -> Int
    func pagesView(_ pagesView: PagesScrollView, pageViewControllerAt index: Int) -> UIViewController
    func pagesView(_ pagesView: PagesScrollView, pageScrollViewAt index: Int) -> UIScrollView
}

class PagesScrollView: UIScrollView {
    var pagesDelegate: PagesScrollViewDelegate?
    var pagesDataSource: PagesScrollViewDataSource?

    let backScrollView = UIScrollView()
    var headerView: UIView? {
        willSet {
            if let oldView = headerView {
                oldView.removeFromSuperview()
            }
            if let newView = newValue {
                addSubview(newView)
            }
        }
    }

    var pageCount = 0
    var currentIndex: Int?
    var currentPage: UIView?
    var currentPageScrollView: UIScrollView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    func reloadPages() {
        setupPages()
    }
    
    func set(currentIndex: Int, animated: Bool = false) {
        let rect = calcPageFrame(At: currentIndex)
        backScrollView.scrollRectToVisible(rect, animated: animated)
    }
}

// MARK: - Private Methods

private extension PagesScrollView {
    func setupSubviews() {
        backScrollView.isPagingEnabled = true
        backScrollView.showsVerticalScrollIndicator = false
        backScrollView.showsHorizontalScrollIndicator = false
        backScrollView.isDirectionalLockEnabled = true
        backScrollView.alwaysBounceHorizontal = true
        backScrollView.bounces = false
        backScrollView.delegate = self
        backScrollView.contentInsetAdjustmentBehavior = .never
        addSubview(backScrollView)
    }
    
    func setupLayout() {
        if let headerView = headerView {
            headerView.anchorToEdge(.top, padding: 0, width: headerView.width, height: headerView.height)
        }
        
        backScrollView.frame = CGRect(x: 0, y: headerView?.yMax ?? 0, width: self.width, height: self.height - (headerView?.height ?? 0))
    }

    func setupPages() {
        guard let count = pagesDataSource?.numberOfPages(in: self), count >= 0 else {
            pageCount = 0
            currentPage = nil
            return
        }
        pageCount = count
        
        for i in 0..<pageCount {
            if let pageVC = pagesDataSource?.pagesView(self, pageViewControllerAt: i) {
                let parentVC = (self as UIView).sc.viewController
                pageVC.willMove(toParent: parentVC)
                parentVC.addChild(pageVC)
                pageVC.didMove(toParent: parentVC)
                backScrollView.addSubview(pageVC.view)
                pageVC.view.frame = calcPageFrame(At: i)
            }
            if let scrollView = pagesDataSource?.pagesView(self, pageScrollViewAt: i) {
//                scrollView.isScrollEnabled = false
//                scrollView.scrollsToTop = false
//                scrollView.showsVerticalScrollIndicator = false
                if i == self.currentIndex {
                    self.currentPageScrollView = scrollView
                }
            }
        }
        self.backScrollView.contentSize = calcBackScrollViewContentSize()
        self.setNeedsLayout()
    }
}

// MARK: - UIScrollViewDelegate

extension PagesScrollView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let selectedIndex = Int(scrollView.contentOffset.x / scrollView.width)
        pagesDelegate?.pagesView(self, dragToSelectPageAt: selectedIndex)
    }
}

// MARK: - Calculate
private extension PagesScrollView {
    func calcFullContentSize() {
        
    }
    
    func calcBackScrollViewContentSize() -> CGSize {
        let width = backScrollView.width * CGFloat(pageCount)
        let height = backScrollView.height
        return CGSize(width: width, height: height)
    }
    
    func calcPageFrame(At index: Int) -> CGRect {
        let width = backScrollView.width
        let height = backScrollView.height
        let x = width * CGFloat(index)
        return CGRect(x: x, y: 0, width: width, height: height)
    }
}
