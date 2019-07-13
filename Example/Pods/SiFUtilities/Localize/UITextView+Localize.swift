//
//  UITextView+Localize.swift
//  SiFUtilities
//
//  Created by FOLY on 12/8/18.
//

import Foundation
import UIKit

@IBDesignable extension UITextView: AssociatedObject {
    @IBInspectable public var textLocalizedKey: String? {
        get {
            return getStringValue(by: &RunTimeKey.localizedTextKey)
        }
        
        set {
            setStringValue(newValue, forRuntimeKey: &RunTimeKey.localizedTextKey)
        }
    }
    
    @objc open override func updateLocalize() {
        if let value = textLocalizedKey, !textLocalizedKey.isNoValue {
            text = value.localized
        }
    }
}
