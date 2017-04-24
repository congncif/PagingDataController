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
    public func animate(duration: CFTimeInterval = 0.35, transitionType: String = kCATransitionFade, direction: String = kCATransitionFromLeft) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = transitionType
        transition.subtype = direction
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.layer.add(transition, forKey: "animation")
    }
    
    public func takeScreenshot() -> UIImage? {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let data = UIImagePNGRepresentation(image!)
        guard data != nil else { return nil }
        return UIImage(data: data!)
    }
}
