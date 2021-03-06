//
//  PagesScrollView.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/3.
//

import UIKit

protocol PagesScrollViewDelegate: UIScrollViewDelegate {
    func pagesView(_ pagesView: PagesScrollView, dragToSelectPageAt index: Int)
    func pagesView(_ pagesView: PagesScrollView, pagingFromIndex fromIndex: Int, toIndex: Int, percent: Double)
}

protocol PagesScrollViewDataSource: NSObjectProtocol {
    func numberOfPages(in pagesView: PagesScrollView) -> Int
    func pagesView(_ pagesView: PagesScrollView, pageViewControllerAt index: Int) -> UIViewController?
    func pagesView(_ pagesView: PagesScrollView, pageViewAt index: Int) -> UIView
    func pagesView(_ pagesView: PagesScrollView, pageScrollViewAt index: Int) -> UIScrollView
}

class PagesScrollView: UIScrollView {
    weak var pagesDelegate: PagesScrollViewDelegate?
    weak var pagesDataSource: PagesScrollViewDataSource?

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
        willSet(scrollView) {
            removeObserver(from: currentPageScrollView)
            addObserver(to: scrollView)
        }
    }

    var scrollerObservation: NSKeyValueObservation?

    // MARK: LifeCycle

    deinit {
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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

        if animated {
            UIView.animate(withDuration: 0.15) {
                self.backScrollView.delegate = nil
                self.backScrollView.scrollRectToVisible(rect, animated: false)
            } completion: { _ in
                self.backScrollView.delegate = self

                self.currentIndex = selectedIndex
                self.currentPage = self.pagesDataSource?.pagesView(self, pageViewAt: selectedIndex)
                self.currentPageScrollView = self.pagesDataSource?.pagesView(self, pageScrollViewAt: selectedIndex)
            }
        } else {
            backScrollView.delegate = nil
            backScrollView.scrollRectToVisible(rect, animated: false)
            backScrollView.delegate = self

            currentIndex = selectedIndex
            currentPage = pagesDataSource?.pagesView(self, pageViewAt: selectedIndex)
            currentPageScrollView = pagesDataSource?.pagesView(self, pageScrollViewAt: selectedIndex)
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

        contentSize = calcFullContentSize()

        backScrollView.frame = calcBackScrollViewFrame()
        backScrollView.contentSize = calcBackScrollViewContentSize()

        if let pageNum = pagesDataSource?.numberOfPages(in: self) {
            for i in 0 ..< pageNum {
                let page = pagesDataSource?.pagesView(self, pageViewAt: i)
                page?.frame = calcPageFrame(At: i)
            }
        }

        if let currentIndex = currentIndex {
            let rect = calcPageFrame(At: currentIndex)
            backScrollView.contentOffset = rect.origin
        }

        currentPageScrollView?.contentOffset = calcCurrentPageContentOffset()
    }

    func setupPages() {
        guard let count = pagesDataSource?.numberOfPages(in: self), count >= 0 else {
            pageCount = 0
            currentPage = nil
            return
        }
        pageCount = count

        for i in 0 ..< pageCount {
            if let pageVC = pagesDataSource?.pagesView(self, pageViewControllerAt: i),
               let parentVC = sc.viewController {
                pageVC.willMove(toParent: parentVC)
                parentVC.addChild(pageVC)
                pageVC.didMove(toParent: parentVC)
            }
            if let page = pagesDataSource?.pagesView(self, pageViewAt: i) {
                backScrollView.addSubview(page)
                page.frame = calcPageFrame(At: i)
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
        if pageCount > 0 {
            currentPageScrollView = pagesDataSource?.pagesView(self, pageScrollViewAt: 0)
        }
        setNeedsLayout()
    }

    func addObserver(to scrollView: UIScrollView?) {
        guard let scrollView = scrollView else {
            return
        }

        scrollerObservation = scrollView.observe(\UIScrollView.contentSize, options: [.old, .new]) { _, _ in
            self.setNeedsLayout()
        }
    }

    func removeObserver(from scrollView: UIScrollView?) {
        guard let observation = scrollerObservation,
              let _ = scrollView else {
            return
        }
        observation.invalidate()
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
        currentPage = pagesDataSource?.pagesView(self, pageViewAt: selectedIndex)
        currentPageScrollView = pagesDataSource?.pagesView(self, pageScrollViewAt: selectedIndex)
    }
}

// MARK: - CalculateFrame

private extension PagesScrollView {
    func calcHeaderFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: width, height: headerView?.height ?? 0)
    }

    func calcFullContentSize() -> CGSize {
        let height = (headerView?.height ?? 0) + (currentPageScrollView?.contentSize.height ?? 0)
        return CGSize(width: width, height: height)
    }

    func calcPageFrame(At index: Int) -> CGRect {
        let width = backScrollView.width
        let height = backScrollView.height
        let x = width * CGFloat(index)
        return CGRect(x: x, y: 0, width: width, height: height)
    }

    func calcBackScrollViewFrame() -> CGRect {
        let y = max(contentOffset.y, headerView?.height ?? 0)
        let topHeight = max((headerView?.height ?? 0) - contentOffset.y, 0)
        let height = self.height - topHeight
        return CGRect(x: 0, y: y, width: width, height: height)
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
