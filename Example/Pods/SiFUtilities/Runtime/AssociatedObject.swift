//
//  AssociatedObject.swift
//  SiFUtilities
//
//  Created by FOLY on 1/26/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation

public protocol AssociatedObject {
    func getAssociatedObject<T>(key: inout UInt8) -> T?
    func setAssociatedObject<T>(key: inout UInt8,
                                value: T?,
                                policy: objc_AssociationPolicy)
}

extension AssociatedObject {
    public func getAssociatedObject<T>(key: inout UInt8) -> T? {
        return objc_getAssociatedObject(self, &key) as? T
    }

    public func setAssociatedObject<T>(key: inout UInt8,
                                       value: T?,
                                       policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, &key, value, policy)
    }
}
