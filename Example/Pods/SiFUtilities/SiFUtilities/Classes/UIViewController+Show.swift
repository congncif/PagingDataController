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
                     animated: Bool = true,
                     completion: (() -> Void)? = nil) {
        if let navigation = baseViewController as? UINavigationController {
            navigation.pushViewController(self, animated: animated)
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: completion)
            }
        } else {
            baseViewController.present(self, animated: animated, completion: completion)
        }
    }
    
    open func show(viewController: UIViewController,
                     from baseviewController: UIViewController? = nil,
                     animated: Bool = true,
                     completion: (() -> Void)? = nil) {
        guard let base = baseviewController else {
            if let navigation = self.navigationController {
                viewController.show(on: navigation, animated: animated, completion: completion)
            } else {
                viewController.show(on: self, animated: animated, completion: completion)
            }
            return
        }
        viewController.show(on: base, animated: animated, completion: completion)
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
                    print("Previous page not found")
                }
            }
        } else if let _ = self.presentingViewController {
            dismiss(animated: animated, completion: completion)
        } else {
            print("Previous page not found")
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
            print("Presenting page not found")
        }
    }
}
