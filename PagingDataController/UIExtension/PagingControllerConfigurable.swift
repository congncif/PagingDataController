//
//  PagingControllerConfigurable.swift
//  PagingDataControllerExtension
//
//  Created by NGUYEN CHI CONG on 3/16/19.
//

import Foundation
import UIKit

public protocol PagingControllerConfigurable: AnyObject {
    var pagingView: PagingControllerViewable { get }
    
    func setupForPaging()
    func refreshPaging()
}

extension PagingControllerConfigurable {
    var instantReloadContent: Bool {
        return pagingView.instantReloadContent
    }

    var pagingScrollView: UIScrollView {
        return pagingView.pagingScrollView
    }

    func startLoading() {
        pagingView.startLoading()
    }

    func stopLoading() {
        pagingView.stopLoading()
    }
}

extension PagingControllerConfigurable where Self: PagingControllerViewable {
    public var pagingView: PagingControllerViewable { return self }
}
