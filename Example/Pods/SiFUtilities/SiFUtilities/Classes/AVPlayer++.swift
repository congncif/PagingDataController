//
//  AV+Extensions.swift
//  SiFUtilities
//
//  Created by Nguyen Chi Cong on 6/10/16.
//  Copyright © 2016 [iF] Solution. All rights reserved.
//

import Foundation
import AVFoundation

extension AVPlayer {
    open func takeImage() -> UIImage? {
        
        let currentItem = self.currentItem
        guard currentItem != nil else {
            return nil
        }
        
        let asset = self.currentItem?.asset
        guard asset != nil else { return nil }
        
        let imageGenerator = AVAssetImageGenerator(asset: asset!)
        
        do {
            let ref = try imageGenerator.copyCGImage(at: (self.currentItem?.currentTime())!, actualTime: nil)
            let viewImage = UIImage(cgImage: ref)
            return viewImage
        }catch (let ex) {
            print(ex)
            return nil
        }
    }
}
