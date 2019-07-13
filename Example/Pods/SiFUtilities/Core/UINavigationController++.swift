//
//  UINavigationController++.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 7/13/19.
//

import Foundation
import UIKit

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
}
