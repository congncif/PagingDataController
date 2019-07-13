//
//  UIImage+Compress.swift
//
//
//  Created by FOLY on 8/19/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    public enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in PNG format
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data.
    /// This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    public var png: Data? { return self.pngData() }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data.
    /// This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    public func jpeg(_ quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
}

extension UIImage {
    public func compress(ratio: CGFloat, minLength: CGFloat = 100) -> UIImage? {
        let size = self.size
        let widthRatio = minLength / size.width
        let heightRatio = minLength / size.height
        let finalRatio = max(widthRatio, heightRatio, ratio)
        return compress(ratio: finalRatio)
    }

    public func withMinLength(_ minLength: CGFloat) -> UIImage? {
        let widthRatio = minLength / size.width
        let heightRatio = minLength / size.height
        let finalRatio = widthRatio > heightRatio ? widthRatio : heightRatio
        return compress(ratio: finalRatio)
    }

    public func compress(ratio: CGFloat) -> UIImage? {
        let size = self.size
        let compressSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: compressSize))
        imageView.image = self
        return imageView.screenshot
    }
}
