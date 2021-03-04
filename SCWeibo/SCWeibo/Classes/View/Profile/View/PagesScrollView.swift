//
//  PagesScrollView.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/3.
//

import BlocksKit
import UIKit

protocol PagesScrollViewDelegate: UIScrollViewDelegate {
    func pagesView(_ pagesView: PagesScrollView, dragToSelectPageAt index: Int)
    func pagesView(_ pagesView: PagesScrollView, pagingFromIndex fromIndex: Int, toIndex: Int, percent: Double)
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
    var currentPageScrollView: UIScrollView? {
        willSet {
            removeObserver(from: currentPageScrollView)
            addObserver(to: newValue)
        }
    }

    var scrollerObserveId: String?

    // MARK: LifeCycle

    deinit {
    }

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
}

// MARK: - Public Methods

extension PagesScrollView {
    func reloadPages() {
        setupPages()
    }

    func set(selectedIndex: Int, animated: Bool = false) {
        let rect = calcPageFrame(At: selectedIndex)

        UIView.animate(withDuration: 0.15) {
            self.backScrollView.delegate = nil
            self.backScrollView.scrollRectToVisible(rect, animated: false)
        } completion: { _ in
            self.backScrollView.delegate = self

            self.currentIndex = selectedIndex
            self.currentPage = self.pagesDataSource?.pagesView(self, pageViewControllerAt: selectedIndex).view
            self.currentPageScrollView = self.pagesDataSource?.pagesView(self, pageScrollViewAt: selectedIndex)
        }
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
        headerView?.frame = calcHeaderFrame()

        self.contentSize = calcFullContentSize()

        if let pageNum = pagesDataSource?.numberOfPages(in: self) {
            for i in 0 ..< pageNum {
                let page = pagesDataSource?.pagesView(self, pageViewControllerAt: i).view
                page?.frame = calcPageFrame(At: i)
            }
        }

        backScrollView.frame = calcBackScrollViewFrame()
        backScrollView.contentSize = calcBackScrollViewContentSize()
        self.currentPageScrollView?.contentOffset = calcCurrentPageContentOffset()
    }

    func setupPages() {
        guard let count = pagesDataSource?.numberOfPages(in: self), count >= 0 else {
            pageCount = 0
            currentPage = nil
            return
        }
        pageCount = count

        for i in 0 ..< pageCount {
            if let pageVC = pagesDataSource?.pagesView(self, pageViewControllerAt: i) {
                let parentVC = (self as UIView).sc.viewController
                pageVC.willMove(toParent: parentVC)
                parentVC.addChild(pageVC)
                pageVC.didMove(toParent: parentVC)
                backScrollView.addSubview(pageVC.view)
                pageVC.view.frame = calcPageFrame(At: i)
            }
            if let scrollView = pagesDataSource?.pagesView(self, pageScrollViewAt: i) {
                scrollView.isScrollEnabled = false
                scrollView.scrollsToTop = false
                scrollView.showsVerticalScrollIndicator = false
                if i == currentIndex {
                    currentPageScrollView = scrollView
                }
            }
        }
        backScrollView.contentSize = calcBackScrollViewContentSize()
        setNeedsLayout()
    }

    func addObservers() {
        bk_addObserver(forKeyPath: "contentOffset", options: [.old, .new]) { _, _ in
            print("contentOffset Changed")
        }
    }

    func addObserver(to scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }

        scrollerObserveId = scrollView.bk_addObserver(forKeyPath: "contentSize", options: [.old, .new]) { _, change in
            self.setNeedsLayout()

            print(change ?? "aaaa")
            print("contentSize Changed")
        }
    }

    func removeObserver(from scrollView: UIScrollView?) {
        guard let identifier = scrollerObserveId,
            let scrollView = scrollView else {
            return
        }

        scrollView.bk_removeObservers(withIdentifier: identifier)
    }
}

// MARK: - UIScrollViewDelegate

extension PagesScrollView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let scrollerWidth = scrollView.width
        let multiple = Double(offsetX / scrollerWidth)
        let fromIndex = currentIndex ?? 0
        let toIndex = multiple > Double(fromIndex) ? (fromIndex + 1) : (fromIndex - 1)
        let percent = abs(multiple - Double(fromIndex))

        pagesDelegate?.pagesView(self, pagingFromIndex: fromIndex, toIndex: toIndex, percent: percent)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let selectedIndex = Int(scrollView.contentOffset.x / scrollView.width)
        pagesDelegate?.pagesView(self, dragToSelectPageAt: selectedIndex)

        currentIndex = selectedIndex
        currentPage = pagesDataSource?.pagesView(self, pageViewControllerAt: selectedIndex).view
        currentPageScrollView = pagesDataSource?.pagesView(self, pageScrollViewAt: selectedIndex)
    }
}

// MARK: - CalculateFrame

private extension PagesScrollView {
    func calcHeaderFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: self.width, height: headerView?.height ?? 0)
    }

    func calcFullContentSize() -> CGSize {
        let height = (headerView?.height ?? 0) + (currentPageScrollView?.contentSize.height ?? 0)
        return CGSize(width: self.width, height: height)
    }

    func calcPageFrame(At index: Int) -> CGRect {
        let width = backScrollView.width
        let height = backScrollView.height
        let x = width * CGFloat(index)
        return CGRect(x: x, y: 0, width: width, height: height)
    }

    func calcBackScrollViewFrame() -> CGRect {
        let y = max(self.contentOffset.y, headerView?.height ?? 0)
        let topHeight = max((headerView?.height ?? 0) - self.contentOffset.y, 0)
        let height = self.height - topHeight
        return CGRect(x: 0, y: y, width: self.width, height: height)
    }

    func calcBackScrollViewContentSize() -> CGSize {
        let width = backScrollView.width * CGFloat(pageCount)
        let height = backScrollView.height
        return CGSize(width: width, height: height)
    }

    func calcCurrentPageContentOffset() -> CGPoint {
        let x = CGFloat(0)
        let y = max(contentOffset.y - (headerView?.height ?? 0), 0)
        return CGPoint(x: x, y: y)
    }
}
