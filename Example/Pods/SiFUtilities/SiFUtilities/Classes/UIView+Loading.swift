//
//  UIView++.swift
//  SiFUtilities
//
//  Created by FOLY on 9/29/16.
//  Copyright © 2016 [iF] Solution. All rights reserved.
//

import Foundation

let LoadingTag = 1111

extension UIView {
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
    
    open func showLoading(blurBackground: Bool = false, customIndicator: UIView? = nil, animated: Bool = true) {
        
        var blurView = self.viewWithTag(LoadingTag)
        
        if blurView == nil {
            
            if blurBackground {
                let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
                blurView = UIVisualEffectView(effect: blur)
            }else {
                blurView = UIView()
            }
            
            blurView?.tag = LoadingTag
            blurView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            var customView: UIView
            if customIndicator == nil {
                let loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
                loadingView.startAnimating()
                
                customView = loadingView
            }else {
                customView = customIndicator!
            }
            
            customView.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
            customView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
            
            blurView?.frame = self.bounds
            blurView?.addSubview(customView)
            
            if animated {
                blurView?.alpha = 0
                self.addSubview(blurView!)
                UIView.animate(withDuration: 0.25, animations: {
                    blurView?.alpha = 1
                    }, completion: nil)
            }else {
                self.addSubview(blurView!)
            }
        }
        
        var count = 0
        count = loadingCount
        self.loadingCount = count + 1
    }
    
    
    open func hideLoading(animated: Bool = true) {
        self.loadingCount = loadingCount - 1
        if loadingCount <= 0 {
            let loadingView = self.viewWithTag(LoadingTag)
            
            if animated {
                UIView.animate(withDuration: 0.25, animations: {
                    loadingView?.alpha = 0
                    }, completion: { (_) in
                        loadingView?.removeFromSuperview()
                })
            }else {
                loadingView?.removeFromSuperview()
            }
        }
    }
}
