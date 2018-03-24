//
//  UIControlRefresh+Block.swift
//  PagingDataController
//
//  Created by FOLY on 3/23/18.
//

import Foundation
import UIKit
import SiFUtilities

var kBlockKey: UInt = 8

extension UIRefreshControl {
    public var actionHandler: ((UIRefreshControl) -> Void)? {
        set {
            objc_setAssociatedObject(self, &kBlockKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        
        get {
            return objc_getAssociatedObject(self, &kBlockKey) as? ((UIRefreshControl) -> Void)
        }
    }
    
    public convenience init(actionHandler:  ((UIRefreshControl) -> Void)?) {
        self.init()
        self.actionHandler = actionHandler
        addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc open func refresh(_ sender: UIRefreshControl) {
        actionHandler?(self)
    }
}
