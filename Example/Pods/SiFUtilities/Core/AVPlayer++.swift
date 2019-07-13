//
//  AV+Extensions.swift
//  SiFUtilities
//
//  Created by Nguyen Chi Cong on 6/10/16.
//  Copyright © 2016 [iF] Solution. All rights reserved.
//

import AVFoundation
import Foundation

extension AVPlayer {
    open func takeImage() -> UIImage? {
        guard let currentItem = self.currentItem, let asset = self.currentItem?.asset else {
            return nil
        }

        let imageGenerator = AVAssetImageGenerator(asset: asset)

        do {
            let ref = try imageGenerator.copyCGImage(at: currentItem.currentTime(), actualTime: nil)
            let viewImage = UIImage(cgImage: ref)
            return viewImage
        } catch let ex {
            assertionFailure(String(describing: ex))
            return nil
        }
    }
}
