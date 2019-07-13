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
        
        let topConstraint = NSLayoutConstraint(item: placeholderView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: topLayoutGuide, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let centerConstraint = NSLayoutConstraint(item: placeholderView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: placeholderView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        
        view.addConstraints([topConstraint, centerConstraint, widthConstraint])
        
        let heightConstraint = NSLayoutConstraint(item: placeholderView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: height)
        
        placeholderView.addConstraint(heightConstraint)
    }
}
