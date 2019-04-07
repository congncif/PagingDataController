//
//  PagingDataConfigurable.swift
//  PagingDataControllerExtension
//
//  Created by NGUYEN CHI CONG on 3/16/19.
//

import Foundation
import SiFUtilities
import SVPullToRefresh
import UIKit

public typealias PullHandler = ((() -> Swift.Void)?) -> Swift.Void

public protocol PagingControllerViewable: AnyObject {
    var instantReloadContent: Bool { get }
    var pagingScrollView: UIScrollView { get }

    func startLoading()
    func stopLoading()
}

extension PagingControllerViewable {
    public var instantReloadContent: Bool { return false }

    public func setupScrollViewForPaging(pullDownHandler: @escaping PullHandler, pullUpHandler: @escaping PullHandler) {
        setupPullToRefreshView(pullHandler: pullDownHandler)
        setupInfiniteScrollingView(pullHanlder: pullUpHandler)
    }

    public func setupPullToRefreshView(pullHandler: @escaping PullHandler) {
        pagingScrollView.addPullToRefresh { [weak self] in
            pullHandler { [weak self] in
                guard let self = self else { return }
                self.pagingScrollView.reloadContent(instantReloadContent: self.instantReloadContent) { [weak self] in
                    self?.pagingScrollView.pullToRefreshView.stopAnimating()
                }
            }
        }
    }

    public func setupInfiniteScrollingView(pullHanlder: @escaping PullHandler) {
        pagingScrollView.addInfiniteScrolling { [weak self] in
            pullHanlder { [weak self] in
                guard let this = self else { return }
                this.pagingScrollView.reloadContent(instantReloadContent: this.instantReloadContent) { [weak self] in
                    self?.pagingScrollView.infiniteScrollingView.stopAnimating()
                }
            }
        }
    }
}

extension PagingControllerViewable where Self: UIViewController {
    public var pagingScrollView: UIScrollView {
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                return scrollView
            }
        }
        fatalError("*** No scroll view in managed by \(classForCoder) ***")
    }

    public func startLoading() {
        showLoading()
    }

    public func stopLoading() {
        hideLoading()
    }
}

extension PagingControllerViewable where Self: PageDataSourceDelegate {
    public func pageDataSourceDidChange(hasNextPage: Bool, nextPageIndicatorShouldChange shouldChange: Bool) {
        defaultPageDataSourceDidChange(hasNextPage: hasNextPage, nextPageIndicatorShouldChange: shouldChange)
    }
    
    public func defaultPageDataSourceDidChange(hasNextPage: Bool, nextPageIndicatorShouldChange shouldChange: Bool) {
        guard shouldChange else { return }
        let delayTime = DispatchTime.now() + 0.25
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            self?.pagingScrollView.showsInfiniteScrolling = hasNextPage
        }
    }
}

