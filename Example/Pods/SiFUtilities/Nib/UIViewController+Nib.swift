//
//  UIViewController+Nib.swift
//  Pods-SiFUtilities_Example
//
//  Created by FOLY on 2/21/18.
//

import Foundation
import UIKit

extension UIViewController {
    fileprivate class func instantiateFromNibHelper<T: UIViewController>() -> T {
        let bundle = Bundle(for: self)
        let controller = T(nibName: T.className, bundle: bundle)
        return controller
    }
    
    open class func instantiateFromNib() -> Self {
        return instantiateFromNibHelper()
    }
}
