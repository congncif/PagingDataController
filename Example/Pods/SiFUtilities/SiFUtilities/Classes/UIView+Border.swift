//
//  UIView+Border.swift
//  Meeting Up
//
//  Created by FOLY on 2/9/17.
//  Copyright © 2017 Julian Heissl. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable extension UIView {
    @IBInspectable open var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable open var borderColor: UIColor? {
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
    
    @IBInspectable open var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
}
