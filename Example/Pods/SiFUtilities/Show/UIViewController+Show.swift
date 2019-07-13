//
//  UIViewController+Show.swift
//  Pods
//
//  Created by FOLY on 7/14/17.
//
//

import Foundation
import UIKit

extension UIViewController {
    open func show(on baseViewController: UIViewController,
                   embedIn NavigationType: UINavigationController.Type = UINavigationController.self,
                   cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel),
                   position: CancelButtonPosition = .left,
                   animated: Bool = true,
                   completion: (() -> Void)? = nil) {
        if let navigation = baseViewController as? UINavigationController {
            navigation.pushViewController(self, animated: animated)
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: completion)
            }
        } else {
            baseViewController.present(self, embedIn: NavigationType, cancelButton: cancelButton, position: position, animated: animated, completion: completion)
        }
    }

    open func show(viewController: UIViewController,
                   from baseviewController: UIViewController? = nil,
                   embedIn NavigationType: UINavigationController.Type = UINavigationController.self,
                   cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel),
                   position: CancelButtonPosition = .left,
                   animated: Bool = true,
                   completion: (() -> Void)? = nil) {
        guard let base = baseviewController else {
            if let navigation = self.navigationController {
                viewController.show(on: navigation, embedIn: NavigationType, cancelButton: cancelButton, position: position, animated: animated, completion: completion)
            } else {
                viewController.show(on: self, embedIn: NavigationType, cancelButton: cancelButton, position: position, animated: animated, completion: completion)
            }
            return
        }
        viewController.show(on: base, embedIn: NavigationType, cancelButton: cancelButton, position: position, animated: animated, completion: completion)
    }

    open func backToPrevious(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let navigation = self.navigationController {
            if navigation.viewControllers.first != self {
                navigation.popViewController(animated: animated)
                if let completion = completion {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: completion)
                }
            } else {
                if let _ = navigation.presentingViewController {
                    navigation.dismiss(animated: animated, completion: completion)
                } else {
                    assertionFailure("Previous page not found")
                }
            }
        } else if let _ = self.presentingViewController {
            dismiss(animated: animated, completion: completion)
        } else {
            assertionFailure("Previous page not found")
        }
    }

    open func forceDismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        if let _ = self.presentingViewController {
            dismiss(animated: animated, completion: completion)
        } else if let navigation = navigationController, let _ = navigation.presentingViewController {
            navigation.dismiss(animated: animated, completion: completion)
        } else if let presented = self.presentedViewController {
            presented.dismiss(animated: animated, completion: completion)
        } else {
            assertionFailure("Presenting page not found")
        }
    }

    open func present(_ vc: UIViewController, embedIn NavigationType: UINavigationController.Type = UINavigationController.self, cancelButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel), position: CancelButtonPosition = .left, animated: Bool = true, completion: (() -> Void)? = nil) {
        if let nav = vc as? UINavigationController {
            nav.topViewController?.showCancelButton(cancelButton, at: position)
            present(nav, animated: animated, completion: completion)
        } else {
            vc.showCancelButton(at: position)
            let nav = NavigationType.init(rootViewController: vc)
            present(nav, animated: animated, completion: completion)
        }
    }
}

extension UIViewController {
    public enum CancelButtonPosition {
        case left
        case right
    }

    open func showCancelButton(_ barButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel), at position: CancelButtonPosition) {
        barButtonItem.action = #selector(dismissButtonDidTap(_:))
        barButtonItem.target = self

        switch position {
        case .left:
            navigationItem.leftBarButtonItem = barButtonItem
        case .right:
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }

    @IBAction open func dismissButtonDidTap(_ sender: Any) {
        forceDismiss()
    }
}

// MARK: - Navigation
