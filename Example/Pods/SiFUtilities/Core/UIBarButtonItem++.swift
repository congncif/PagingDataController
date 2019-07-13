//
//  UIBarButtonItem++.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 7/13/19.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    public convenience init(barButtonSystemItem: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: barButtonSystemItem, target: nil, action: nil)
    }

    public convenience init(title: String?, style: UIBarButtonItem.Style) {
        self.init(title: title, style: style, target: nil, action: nil)
    }

    public convenience init(image: UIImage?, style: UIBarButtonItem.Style) {
        self.init(image: image, style: style, target: nil, action: nil)
    }

    public convenience init(image: UIImage, landscapeImagePhone: UIImage, style: UIBarButtonItem.Style) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
    }
}

extension UIBarButtonItem {
    public static func backBarButtonItem(title: String = "") -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
    }
}
