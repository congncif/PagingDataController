//
//  UIView++.swift
//  SiFUtilities
//
//  Created by FOLY on 9/29/16.
//  Copyright © 2016 [iF] Solution. All rights reserved.
//

import Foundation

extension UIView {
    private struct Tag {
        static let loading = 1111
    }
    
    fileprivate struct AssociatedKeys {
        static var LoadingCount = 0
    }
    
    public var loadingCount: Int {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.LoadingCount) as? NSNumber
            guard number != nil else { return 0 }
            return number!.intValue
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.LoadingCount,
                NSNumber(value: newValue as Int),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    @objc open func showLoading(overlayView: UIView = UIView(),
                                customIndicator: UIView? = nil,
                                animated: Bool = true) {
        var blurView = self.viewWithTag(Tag.loading)
        if blurView == nil {
            blurView = overlayView
            
            blurView?.tag = Tag.loading
            blurView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            var customView: UIView
            if customIndicator == nil {
                let loadingView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
                loadingView.startAnimating()
                
                customView = loadingView
            } else {
                customView = customIndicator!
            }
            
            customView.center = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
            customView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
            
            blurView?.frame = self.bounds
            blurView?.addSubview(customView)
            
            if animated {
                if let blur = blurView as? UIVisualEffectView {
                    customView.alpha = 0
                    UIView.animate(withDuration: 0.25, animations: {
                        customView.alpha = 1
                    }, completion: nil)
                    
                    let eff = blur.effect
                    blur.effect = nil
                    self.addSubview(blur)
                    UIView.animate(withDuration: 0.25, animations: {
                        blur.effect = eff
                    }, completion: nil)
                    
                } else {
                    blurView?.alpha = 0
                    self.addSubview(blurView!)
                    UIView.animate(withDuration: 0.25, animations: {
                        blurView?.alpha = 1
                    }, completion: nil)
                }
            } else {
                self.addSubview(blurView!)
            }
        }
        
        var count = 0
        count = loadingCount
        self.loadingCount = count + 1
    }
    
    @objc open func hideLoading(animated: Bool = true) {
        self.loadingCount = self.loadingCount - 1
        if self.loadingCount <= 0 {
            let loadingView = self.viewWithTag(Tag.loading)
            if animated {
                if let blur = loadingView as? UIVisualEffectView {
                    UIView.animate(withDuration: 0.25, animations: {
                        blur.effect = nil
                    }, completion: { _ in
                        loadingView?.removeFromSuperview()
                    })
                } else {
                    UIView.animate(withDuration: 0.25, animations: {
                        loadingView?.alpha = 0
                    }, completion: { _ in
                        loadingView?.removeFromSuperview()
                    })
                }
            } else {
                loadingView?.removeFromSuperview()
            }
        }
    }
}
