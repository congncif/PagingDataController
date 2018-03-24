//
//  UIViewController+PagingData.swift
//  PagingDataControllerExtension
//
//  Created by NGUYEN CHI CONG on 8/11/16.
//  Copyright © 2016 FOLY. All rights reserved.
//

import Foundation
import PagingDataController
import SiFUtilities
import SVPullToRefresh

public typealias PullHandler = ((() -> Swift.Void)?) -> Swift.Void

extension UIViewController: PageDataSourceDelegate {
    @objc open var instantReloadContent: Bool {
        return false
    }
    
    @objc open var pagingScrollView: UIScrollView {
        for subview in view.subviews {
            if let scrollView = subview as? UIScrollView {
                return scrollView
            }
        }
        fatalError("*** No scroll view in managed by \(classForCoder) ***")
    }
    
    // MARK: - Setup layout
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func setupScrollViewForPaging(pullDownHandler: @escaping PullHandler, pullUpHandler: @escaping PullHandler) {
        setupPullToRefreshView(pullHandler: pullDownHandler)
        setupInfiniteScrollingView(pullHanlder: pullUpHandler)
    }
    
    public func setupPullToRefreshView(pullHandler: @escaping PullHandler) {
        pagingScrollView.addPullToRefresh { [weak self] in
            pullHandler({ [weak self] in
                self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!,
                                                     end: { [weak self] in
                                                         self?.pagingScrollView.pullToRefreshView.stopAnimating()
                })
            })
        }
    }
    
    public func setupInfiniteScrollingView(pullHanlder: @escaping PullHandler) {
        pagingScrollView.addInfiniteScrolling { [weak self] in
            pullHanlder({ [weak self] in
                self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!,
                                                     end: { [weak self] in
                                                         self?.pagingScrollView.infiniteScrollingView.stopAnimating()
                })
            })
        }
    }
    
    // MARK: - Page Data Delegate
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @objc open func pageDataSourceDidChanged(hasMoreFlag: Bool, changed: Bool) {
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
    
    @objc open func startLoading() {
        showLoading()
    }
    
    @objc open func stopLoading() {
        hideLoading()
    }
}

@objc public enum PagingFirstLoadStyle: Int {
    case none
    case autoTrigger
    case progressHUD // Heads-up Display
}

let kRefreshControlTag = 1005

extension PagingControllerProtocol where Self: UIViewController {
    public func setupForPagingDataSource() {
        dataSource.settings = PageDataSettings(pageSize: provider.pageSize)
        dataSource.delegate = self
    }
    
    public func setupForPullDownToRefresh(nativeControl: Bool = false) {
        if nativeControl {
            let refreshControl = UIRefreshControl(actionHandler: { [weak self] control in
                self?.loadFirstPageWithCompletion({ [weak self] in
                    self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!,
                                                         end: {
                                                            control.endRefreshing()
                    })
                })
            })
            refreshControl.tag = kRefreshControlTag
            pagingScrollView.addSubview(refreshControl)
        } else {
            pagingScrollView.addPullToRefresh { [weak self] in
                self?.loadFirstPageWithCompletion({ [weak self] in
                    self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!,
                                                         end: { [weak self] in
                                                             self?.pagingScrollView.pullToRefreshView.stopAnimating()
                    })
                })
            }
        }
    }
    
    public func setupForPullUpToLoadMore() {
        pagingScrollView.addInfiniteScrolling { [weak self] in
            self?.loadNextPageWithCompletion({ [weak self] in
                self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!,
                                                     end: { [weak self] in
                                                         self?.pagingScrollView.infiniteScrollingView.stopAnimating()
                })
            })
        }
    }
    
    public func setupForPaging(nativeRefreshControl: Bool = false, firstLoadstyle: PagingFirstLoadStyle = .progressHUD) {
        setupForPagingDataSource()
        setupForPullDownToRefresh(nativeControl: nativeRefreshControl)
        setupForPullUpToLoadMore()
        
        switch firstLoadstyle {
        case .autoTrigger:
            triggerPull(nativeRefreshControl: nativeRefreshControl)
        case .progressHUD:
            loadDataFirstPage()
        default:
            break
        }
    }
    
    public func triggerPull(nativeRefreshControl: Bool = false) {
        if nativeRefreshControl {
            if let control = pagingScrollView.viewWithTag(kRefreshControlTag) as? UIRefreshControl {
                control.beginRefreshing()
                loadFirstPageWithCompletion({ [weak self] in
                    self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!, end: control.endRefreshing)
                })
            } else {
                print("*** Refresh control not found ***")
            }
        } else {
            pagingScrollView.triggerPullToRefresh()
        }
    }
    
    public func loadDataFirstPage() {
        startLoading()
        loadFirstPageWithCompletion({ [weak self] in
            self?.pagingScrollView.reloadContent(instantReloadContent: (self?.instantReloadContent)!, end: self?.stopLoading)
        })
    }
}
