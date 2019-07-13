//
//  UITabBarController++.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 7/13/19.
//

import Foundation
import UIKit

extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}
