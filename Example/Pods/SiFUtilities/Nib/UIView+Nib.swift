//
//  UIView+Nib.swift
//  SiFUtilities
//
//  Created by FOLY on 2/21/18.
//

import Foundation
import UIKit

extension UIView {
    fileprivate class func loadFromNibHelper<T: UIView>() -> T {
        let bundle = Bundle(for: self)
        let view = bundle.loadNibNamed(T.className, owner: nil, options: nil)?.first as! T
        return view
    }

    open class func loadFromNib() -> Self {
        return loadFromNibHelper()
    }
}
