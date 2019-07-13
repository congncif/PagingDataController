//
//  UISegmentControl+Localize.swift
//  SiFUtilities
//
//  Created by FOLY on 12/8/18.
//

import Foundation
import UIKit

/// The segment titles are separated by single character ',' (no space). For example: 'title1,title2,title3'

@IBDesignable extension UISegmentedControl: AssociatedObject {
    @IBInspectable public var titlesLocalizedKey: String? {
        get {
            return getStringValue(by: &RunTimeKey.localizedArrayKey)
        }

        set {
            setStringValue(newValue, forRuntimeKey: &RunTimeKey.localizedArrayKey)
        }
    }

    @objc open override func updateLocalize() {
        if let value = titlesLocalizedKey, !titlesLocalizedKey.isNoValue {
            let components = value.components(separatedBy: ",")
            for i in 0..<self.numberOfSegments {
                if i < components.count {
                    let title = components[i]
                    setTitle(title.localized, forSegmentAt: i)
                }
            }
        }
    }
}
