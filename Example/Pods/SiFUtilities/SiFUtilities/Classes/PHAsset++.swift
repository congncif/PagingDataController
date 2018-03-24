//
//  PHAsset++.swift
//  Pods-SiFUtilities_Example
//
//  Created by FOLY on 1/31/18.
//

import Foundation
import Photos

extension PHAsset {
    open func thumbnail(size: CGSize = CGSize(width: 180, height: 180)) -> UIImage? {
        let manager = PHImageManager.default
        let options = PHImageRequestOptions()
        var thumbnail: UIImage?
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: scale * size.width, height: scale * size.height)
        
        manager().requestImage(for: self, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: {(result, info)->Void in
            if let img = result {
                thumbnail = img
            }
        })
        return thumbnail
    }
    
    open func cacheThumbnail(size: CGSize = CGSize(width: 180, height: 180)) -> UIImage? {
        let manager = PHCachingImageManager()
        let options = PHImageRequestOptions()
        var thumbnail: UIImage?
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        
        let scale = UIScreen.main.scale
        let targetSize = CGSize(width: scale * size.width, height: scale * size.height)
        
        manager.requestImage(for: self, targetSize: targetSize, contentMode: .aspectFill, options: nil, resultHandler: {(result, info)->Void in
            if let img = result {
                thumbnail = img
            }
        })
        return thumbnail
    }
    
    open func imageAssetInfo() -> (imageData: Data?, fileName: String?){
        var imageData: Data?
        var fileName: String?
        
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            let manager = PHImageManager.default
            let options = PHImageRequestOptions()
            
            options.isNetworkAccessAllowed = true
            options.isSynchronous = true
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            
            manager().requestImageData(for: self, options: options) { (data, dataUTI, orientation, info) in
                imageData = data
                if info!.keys.contains(NSString(string: "PHImageFileURLKey")) {
                    let path = info![NSString(string: "PHImageFileURLKey")] as! NSURL
                    fileName = path.lastPathComponent
                    
                } else if info!.keys.contains("PHImageFileDataKey") {
                    fileName = String.random(length: 10)
                }
                semaphore.signal()
            }
        }
        semaphore.wait()
        return (imageData, fileName)
    }
    
    open func exportVideo(to url: URL) {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            let manager = PHImageManager.default
            let options = PHVideoRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat
            
            manager().requestAVAsset(forVideo: self, options: options, resultHandler: { (asset, mix, info) in
                if let avurlAsset = asset as? AVURLAsset {
                    do {
                        try FileManager.default.copyItem(at: avurlAsset.url, to: url)
                    } catch {
                        print("Can not copy video")
                    }
                } else {
                    print("No valid data")
                }
                semaphore.signal()
            })
        }
        semaphore.wait()
    }
}
