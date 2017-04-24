//
//  UIView+Border.swift
//  Meeting Up
//
//  Created by FOLY on 2/9/17.
//  Copyright © 2017 Julian Heissl. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public extension UIView {
    @IBInspectable public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
}
