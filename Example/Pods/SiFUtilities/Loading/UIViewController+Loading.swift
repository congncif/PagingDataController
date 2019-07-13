//
//  UIViewController+Loading.swift
//  SiFUtilities
//
//  Created by FOLY on 9/22/18.
//

import Foundation
import UIKit

extension UIViewController {
    // MARK: - Loading
    @objc open func showLoading() {
        self.view.showLoading()
    }
    
    @objc open func hideLoading() {
        self.view.hideLoading()
    }
}
