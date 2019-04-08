//
//  PagingControllerProtocolExtension.swift
//  PagingDataControllerExtension
//
//  Created by NGUYEN CHI CONG on 3/16/19.
//

import Foundation
import UIKit

@objc public enum PagingFirstLoadingStyle: Int {
    case none
    case autoTrigger
    case progressHUD // Heads-up Display
}

extension PagingControllerProtocol {
    public func setupPagingDataSource(delegate: PageDataSourceDelegate?) {
        dataSource.delegate = delegate
    }
    
    public func setupPullDownToRefresh(pagingView: PagingControllerViewable, nativeControl: Bool = false) {
        if nativeControl {
            let refreshControl = UIRefreshControl { [weak self] control in
                self?.loadFirstPageWithCompletion { [weak pagingView] in
                    guard let pagingView = pagingView else { return }
                    pagingView.pagingScrollView.reloadContent(instantReloadContent: pagingView.instantReloadContent) {
                        control.endRefreshing()
                    }
                }
            }
            
            if #available(iOS 10.0, *) {
                pagingView.pagingScrollView.refreshControl = refreshControl
            } else {
                pagingView.pagingScrollView.addSubview(refreshControl)
            }
        } else {
            pagingView.pagingScrollView.addPullToRefresh { [weak self] in
                self?.loadFirstPageWithCompletion { [weak pagingView] in
                    guard let pagingView = pagingView else { return }
                    pagingView.pagingScrollView.reloadContent(instantReloadContent: pagingView.instantReloadContent) { [weak pagingView] in
                        pagingView?.pagingScrollView.pullToRefreshView.stopAnimating()
                    }
                }
            }
        }
    }
    
    public func setupPullUpToLoadMore(pagingView: PagingControllerViewable) {
        pagingView.pagingScrollView.addInfiniteScrolling { [weak self] in
            self?.loadNextPageWithCompletion { [weak pagingView] in
                guard let pagingView = pagingView else { return }
                pagingView.pagingScrollView.reloadContent(instantReloadContent: pagingView.instantReloadContent) { [weak pagingView] in
                    pagingView?.pagingScrollView.infiniteScrollingView.stopAnimating()
                }
            }
        }
        
        pagingView.pagingScrollView.showsInfiniteScrolling = dataSource.hasMore
    }
    
    public func triggerRefresh(pagingView: PagingControllerViewable, nativeRefreshControl: Bool = false) {
        if nativeRefreshControl {
            if let control = pagingView.pagingScrollView.nativeRefreshControl {
                control.beginRefreshing()
                loadFirstPageWithCompletion { [weak pagingView] in
                    guard let pagingView = pagingView else { return }
                    pagingView.pagingScrollView.reloadContent(instantReloadContent: pagingView.instantReloadContent,
                                                              end: control.endRefreshing)
                }
            } else {
                print("*** Refresh control not found ***")
            }
        } else {
            pagingView.pagingScrollView.triggerPullToRefresh()
        }
    }
    
    public func loadDataFirstPage(pagingView: PagingControllerViewable) {
        pagingView.startLoading()
        loadFirstPageWithCompletion { [weak pagingView] in
            guard let pagingView = pagingView else { return }
            pagingView.pagingScrollView.reloadContent(instantReloadContent: pagingView.instantReloadContent,
                                                      end: pagingView.stopLoading)
        }
    }
    
    public func setupPagingControlling(pagingView: PagingControllerViewable,
                                       nativeRefreshControl: Bool = false,
                                       firstLoadingStyle style: PagingFirstLoadingStyle = .progressHUD) {
        setupPullDownToRefresh(pagingView: pagingView, nativeControl: nativeRefreshControl)
        setupPullUpToLoadMore(pagingView: pagingView)
        
        switch style {
        case .autoTrigger:
            triggerRefresh(pagingView: pagingView, nativeRefreshControl: nativeRefreshControl)
        case .progressHUD:
            loadDataFirstPage(pagingView: pagingView)
        default:
            break
        }
    }
}

extension PagingControllerConfigurable where Self: PagingControllerProtocol {
    public func setupForPaging() {
        setupPagingControlling(pagingView: pagingView, nativeRefreshControl: true, firstLoadingStyle: .progressHUD)
    }
    
    public func refreshPaging() {
        loadDataFirstPage(pagingView: pagingView)
    }
}

extension PagingControllerProtocol where Self.PagingProvider == Self {
    public var provider: PagingProvider {
        return self
    }
}
