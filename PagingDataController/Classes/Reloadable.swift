//
//  Reloadable.swift
//  PagingDataController
//
//  Created by NGUYEN CHI CONG on 8/11/16.
//  Copyright © 2016 FOLY. All rights reserved.
//

import Foundation
import UIKit

public protocol Reloadable {
    func reloadContent(instantReloadContent flag: Bool, end: (() -> ())?)
}

extension Reloadable {
    public func reloadContent(instantReloadContent flag: Bool = false, end: (() -> ())? = nil) {
    }
}

extension UIScrollView: Reloadable {
    func reload(_ reloadBlock: (() -> ()), instantReloadContent flag: Bool = false, end: (() -> ())? = nil ) {
        if flag {
            reloadBlock()
            end?()
        } else {
            end?()
            reloadBlock()
        }
    }
}

extension UITableView {
    open func reloadContent(instantReloadContent flag: Bool = false, end: (() -> ())? = nil) {
        reload({ [unowned self] in
            self.reloadData()
            }, instantReloadContent: flag, end: end)
    }
}

extension UICollectionView {
    open func reloadContent(instantReloadContent flag: Bool = false, end: (() -> ())? = nil) {
        reload({ [unowned self] in
            self.reloadData()
            }, instantReloadContent: flag, end: end)
    }
}

