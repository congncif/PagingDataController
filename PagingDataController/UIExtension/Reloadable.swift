//
//  Reloadable.swift
//  PagingDataController
//
//  Created by NGUYEN CHI CONG on 8/11/16.
//  Copyright © 2016 FOLY. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol Reloadable {
    func reloadContent(instantReloadContent flag: Bool, end: (() -> ())?)
}

extension UIScrollView: Reloadable {
    open func reload(_ reloadBlock: () -> (), instantReloadContent flag: Bool = false, end: (() -> ())? = nil) {
        if flag {
            reloadBlock()
            end?()
        } else {
            end?()
            reloadBlock()
        }
    }

    @objc open func reloadContent(instantReloadContent flag: Bool = false, end: (() -> ())? = nil) {
        fatalError("Must implement \(#function) to reload content")
    }
}

extension UITableView {
    @objc open override func reloadContent(instantReloadContent flag: Bool = false, end: (() -> ())? = nil) {
        reload({ [unowned self] in
            self.reloadData()
        }, instantReloadContent: flag, end: end)
    }
}

extension UICollectionView {
    @objc open override func reloadContent(instantReloadContent flag: Bool = false, end: (() -> ())? = nil) {
        reload({ [unowned self] in
            self.reloadData()
        }, instantReloadContent: flag, end: end)
    }
}
