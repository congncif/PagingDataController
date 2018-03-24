//
//  UIViewController+Utils.swift
//  SiFUtilities
//
//  Created by FOLY on 1/11/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    open func addPlaceholderStatusView(height: CGFloat = UIApplication.shared.statusBarFrame.size.height) {
        
        let placeholderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: height))
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.backgroundColor = navigationController?.navigationBar.barTintColor
        view.addSubview(placeholderView)
        
        let topConstraint = NSLayoutConstraint(item: placeholderView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let centerConstraint = NSLayoutConstraint(item: placeholderView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: placeholderView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        
        view.addConstraints([topConstraint, centerConstraint, widthConstraint])
        
        let heightConstraint = NSLayoutConstraint(item: placeholderView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
        
        placeholderView.addConstraint(heightConstraint)
    }
    
    // MARK: - Loading
    @objc open func showLoading() {
        self.view.showLoading()
    }
    
    @objc open func hideLoading() {
        self.view.hideLoading()
    }
}
