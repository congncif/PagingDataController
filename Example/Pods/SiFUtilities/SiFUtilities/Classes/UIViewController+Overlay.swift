//
//  UIViewController+Child.swift
//
//
//  Created by FOLY on 2/20/18.
//  Copyright © 2018 [iF] Solution. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    @objc public func displayContentController(content: UIViewController, animation: ((UIView) -> Void)? = { v in v.fade() }) {
        addChildViewController(content)
        content.view.frame = view.bounds
        content.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(content.view)
        animation?(view)
        content.didMove(toParentViewController: self)
    }

    @objc public func hideContentController(content: UIViewController, animation: ((UIView) -> Void)? = { v in v.fade() }) {
        content.willMove(toParentViewController: nil)
        let superView = content.view.superview
        animation?(superView ?? view)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }

    @objc public func showOverlay(on viewController: UIViewController, animation: ((UIView) -> Void)? = { v in v.fade() }) {
        viewController.displayContentController(content: self, animation: animation)
    }

    @objc public func hideOverlay(animation: ((UIView) -> Void)? = { v in v.fade() }) {
        willMove(toParentViewController: nil)
        let superView = view.superview
        animation?(superView ?? view)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}
