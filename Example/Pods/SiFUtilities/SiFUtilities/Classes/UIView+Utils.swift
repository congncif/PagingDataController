//
//  UIView+Utils.swift
//  SiFUtilities
//
//  Created by FOLY on 1/11/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    open func takeImage() -> UIImage? {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let data = UIImagePNGRepresentation(image!)
        guard data != nil else { return nil }
        return UIImage(data: data!)
    }
}
