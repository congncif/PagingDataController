//
//  UIViewController+Popover.swift
//  BomShop
//
//  Created by FOLY on 12/1/18.
//  Copyright © 2018 [iF] Solution. All rights reserved.
//

import Foundation
import UIKit

public protocol PopoverPresentable: class, UIPopoverPresentationControllerDelegate {
    func presentPopover(_ contentViewController: UIViewController,
                        from sourceView: UIView,
                        arrowDirections: UIPopoverArrowDirection,
                        backgroundColor: UIColor,
                        animated: Bool,
                        completion: (() -> Void)?)
    func presentPopover(_ contentViewController: UIViewController,
                        fromBarItem barButtonItem: UIBarButtonItem,
                        arrowDirections: UIPopoverArrowDirection,
                        backgroundColor: UIColor,
                        animated: Bool,
                        completion: (() -> Void)?)
}

extension UIViewController: PopoverPresentable {
    public func presentPopover(_ contentViewController: UIViewController,
                               from sourceView: UIView,
                               arrowDirections: UIPopoverArrowDirection = .any,
                               backgroundColor: UIColor = .white,
                               animated: Bool = true,
                               completion: (() -> Void)? = nil) {
        contentViewController.modalPresentationStyle = .popover
        contentViewController.popoverPresentationController?.backgroundColor = backgroundColor
        contentViewController.popoverPresentationController?.delegate = self
        contentViewController.popoverPresentationController?.sourceView = sourceView
        contentViewController.popoverPresentationController?.sourceRect = sourceView.bounds
        contentViewController.popoverPresentationController?.permittedArrowDirections = arrowDirections
        present(contentViewController, animated: animated, completion: completion)
    }

    public func presentPopover(_ contentViewController: UIViewController,
                               fromBarItem barButtonItem: UIBarButtonItem,
                               arrowDirections: UIPopoverArrowDirection = .any,
                               backgroundColor: UIColor = .white,
                               animated: Bool = true,
                               completion: (() -> Void)? = nil) {
        contentViewController.modalPresentationStyle = .popover
        contentViewController.popoverPresentationController?.backgroundColor = backgroundColor
        contentViewController.popoverPresentationController?.delegate = self
        contentViewController.popoverPresentationController?.barButtonItem = barButtonItem
        contentViewController.popoverPresentationController?.permittedArrowDirections = arrowDirections
        present(contentViewController, animated: animated, completion: completion)
    }

    @objc public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
