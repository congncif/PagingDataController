//
//  Swizzling.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 4/24/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation
import UIKit

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
        types.deallocate(capacity: typeCount)
    }
}

extension UIApplication {
    private static let runOnce: Void = {
        SwizzlingEntry.swizzling()
        UIViewController.swizzling()
    }()
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}
