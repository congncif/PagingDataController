//
//  UISearchBar+Localize.swift
//  SiFUtilities
//
//  Created by FOLY on 12/8/18.
//

import Foundation
import UIKit

@IBDesignable extension UISearchBar: AssociatedObject {
    @IBInspectable public var placeholderLocalizedKey: String? {
        get {
            return getStringValue(by: &RunTimeKey.localizedPlaceholderTextKey)
        }
        
        set {
            setStringValue(newValue, forRuntimeKey: &RunTimeKey.localizedPlaceholderTextKey)
        }
    }
    
    @objc open override func updateLocalize() {
        if let value = placeholderLocalizedKey, !placeholderLocalizedKey.isNoValue {
            placeholder = value.localized
        }
    }
}

