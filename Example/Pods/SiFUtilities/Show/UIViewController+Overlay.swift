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
    public typealias OverlayAnimationBlock = (_ container: UIView, _ overlay: UIView) -> Void

    public struct OverlayAnimation {
        public static var fade: OverlayAnimationBlock = { container, _ in container.fade() }
    }

    @objc public func displayContentController(content: UIViewController,
                                               animation: OverlayAnimationBlock = OverlayAnimation.fade) {
        addChild(content)

        content.willMove(toParent: self)

        content.view.frame = view.bounds
        content.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(content.view)
        animation(view, content.view)

        content.didMove(toParent: self)
    }

    @objc public func hideContentController(content: UIViewController,
                                            animation: OverlayAnimationBlock = OverlayAnimation.fade) {
        content.willMove(toParent: nil)

        let superView = content.view.superview ?? view!
        animation(superView, view)
        content.view.removeFromSuperview()

        content.removeFromParent()

        content.didMove(toParent: nil)
    }

    @objc public func showOverlay(on viewController: UIViewController,
                                  animation: OverlayAnimationBlock = OverlayAnimation.fade) {
        viewController.displayContentController(content: self, animation: animation)
    }

    @objc public func hideOverlay(animation: OverlayAnimationBlock = OverlayAnimation.fade) {
        willMove(toParent: nil)

        let superView = view.superview ?? view!
        animation(superView, view)

        view.removeFromSuperview()

        removeFromParent()
        didMove(toParent: nil)
    }
}
