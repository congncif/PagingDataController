//
//  Swizzling.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 4/24/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    open class func swizzledMethod(_ swizzledClass: AnyClass, originalSelector: Selector, to swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(swizzledClass, originalSelector),
            let swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector) else {
            return
        }
        
        let didAddMethod = class_addMethod(
            swizzledClass,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        
        if didAddMethod {
            class_replaceMethod(
                swizzledClass,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    open class func exchangeMethod(originalSelector: Selector, to swizzledSelector: Selector) {
        self.swizzledMethod(self, originalSelector: originalSelector, to: swizzledSelector)
    }
}

public protocol SelfAware: class {
    static func awake()
}

class SwizzlingEntry {
    static func swizzling() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)

        #if swift(>=4.0)
            let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        #else
            let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass?>(types)
        #endif

        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount { (types[index] as? SelfAware.Type)?.awake() }

        #if swift(>=4.1)
            types.deallocate()
        #else
            types.deallocate(capacity: typeCount)
        #endif
    }
}

extension UIApplication {
    private static let runOnce: Void = {
        SwizzlingEntry.swizzling()
        UIViewController.swizzling()
    }()
    
    open override var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}
