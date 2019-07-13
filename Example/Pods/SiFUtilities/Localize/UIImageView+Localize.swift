//
//  UIImageView++.swift
//  SiFUtilities
//
//  Created by FOLY on 9/10/18.
//

import Foundation

@IBDesignable extension UIImageView: AssociatedObject {
    @IBInspectable public var imageNameLocalizedKey: String? {
        get {
            return getStringValue(by: &RunTimeKey.localizedImageNameKey)
        }

        set {
            setStringValue(newValue, forRuntimeKey: &RunTimeKey.localizedImageNameKey)
        }
    }

    @objc open override func updateLocalize() {
        if !imageNameLocalizedKey.isNoValue, let name = imageNameLocalizedKey {
            let assetImage = UIImage(named: name)
            image = assetImage
        }
    }
}
