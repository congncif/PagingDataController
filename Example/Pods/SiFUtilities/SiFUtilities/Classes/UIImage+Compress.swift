//
//  ImageCompress.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 2/6/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    public func compress(ratio: CGFloat, minLength: CGFloat = 100) -> UIImage? {
        let size = self.size
        let widthRatio = minLength/size.width
        let heightRatio = minLength/size.height
        let finalRatio = max(widthRatio, heightRatio, ratio)
        return compress(ratio: finalRatio)
    }
    
    public func withMinLength(_ minLength: CGFloat) -> UIImage? {
        let widthRatio = minLength/size.width
        let heightRatio = minLength/size.height
        let finalRatio = widthRatio > heightRatio ? widthRatio : heightRatio
        return compress(ratio: finalRatio)
    }
    
    public func compress(ratio: CGFloat) -> UIImage? {
        let size = self.size
        let compressSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: compressSize))
        imageView.image = self
        return imageView.takeImage()
    }
}
