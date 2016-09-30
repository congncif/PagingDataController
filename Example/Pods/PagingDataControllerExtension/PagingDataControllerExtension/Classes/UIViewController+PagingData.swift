//
//  PagingInterfaceProtocol+UI.swift
//  Clip2
//
//  Created by NGUYEN CHI CONG on 8/11/16.
//  Copyright © 2016 FOLY. All rights reserved.
//

import Foundation
import SiFUtilities
import SVPullToRefresh
import PagingDataController

public typealias PullHandler = ((() -> Swift.Void)? ) -> Swift.Void

extension UIViewController: PageDataSourceDelegate {
    
    open var instantReloadContent: Bool {
        return false
    }
    
    open var pagingScrollView: UIScrollView {
        for subview in self.view.subviews {
            if subview is UIScrollView {
                return subview as! UIScrollView
            }
        }
        fatalError("No scroll view in managed by \(self.classForCoder)")
    }
    
    // MARK: - Setup layout
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func setupScrollViewForPaging(pullDownHandler: @escaping PullHandler, pullUpHandler: @escaping PullHandler) {
        self.setupPullToRefreshView(pullHandler: pullDownHandler)
        self.setupInfiniteScrollingView(pullHanlder: pullUpHandler)
    }
    
    public func setupPullToRefreshView(pullHandler: @escaping PullHandler) {
        pagingScrollView.addPullToRefresh { [weak self] in
            pullHandler({ [weak self] in
                self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!, end: {
                    [weak self] in
                    self?.pagingScrollView.pullToRefreshView.stopAnimating()
                    })
                })
        }
    }
    
    public func setupInfiniteScrollingView(pullHanlder: @escaping PullHandler) {
        pagingScrollView.addInfiniteScrolling { [weak self] in
            pullHanlder({ [weak self] in
                self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!, end: {
                    [weak self] in
                    self?.pagingScrollView.infiniteScrollingView.stopAnimating()
                    })
                })
        }
    }
    
    // MARK: - Page Data Delegate
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open func pageDataSourceDidChanged(hasMoreFlag: Bool, changed: Bool) {
        
        guard changed else {
            return
        }
        let delayTime = DispatchTime.now() + Double(Int64(0.25 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
            
            if hasMoreFlag == false {
                self?.pagingScrollView.showsInfiniteScrolling = false
            } else {
                self?.pagingScrollView.showsInfiniteScrolling = true
            }
        }
        
    }
    
    open func startLoading() {
        showLoading()
    }
    
    open func stopLoading() {
        hideLoading()
    }
}

extension PagingControllerProtocol where Self: UIViewController {
    
    public func setupForPaging(loadFirstPage: Bool = true) {
        
        dataSource.settings = PageDataSettings(pageSize: provider.pageSize)
        dataSource.delegate = self
        
        pagingScrollView.addPullToRefresh { [weak self] in
            self?.loadFirstPageWithCompletion ({ [weak self] in
                self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!, end: {
                    [weak self] in
                    self?.pagingScrollView.pullToRefreshView.stopAnimating()
                    })
                })
        }
        pagingScrollView.addInfiniteScrolling { [weak self] in
            self?.loadNextPageWithCompletion ({ [weak self] in
                self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!, end: {
                    [weak self] in
                    self?.pagingScrollView.infiniteScrollingView.stopAnimating()
                    })
                })
        }
        
        if loadFirstPage {
            loadDataAtFirst()
        }
    }
    
    public func loadDataAtFirst() {
        startLoading()
        loadFirstPageWithCompletion({ [weak self] in
            self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!, end: self?.stopLoading)
            })
    }
}


