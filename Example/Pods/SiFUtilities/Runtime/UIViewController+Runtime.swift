//
//  UIExtensions.swift
//  PagingDataController
//
//  Created by FOLY on 5/28/16.
//  Copyright © 2016 FOLY. All rights reserved.
//

import Foundation

extension UIViewController {
    // MARK: - Runtime properties
    
    fileprivate struct AssociatedKeys {
        static var isViewLayoutFinished = false
        static var didDisplay = false
        static var willDisplay = false
    }
    
    public private(set) var isViewLayoutFinished: Bool {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.isViewLayoutFinished) as? NSNumber
            guard let _number = number else { return false }
            return _number.boolValue
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.isViewLayoutFinished, NSNumber(value: newValue as Bool), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public private(set) var isViewDidDisplay: Bool {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.didDisplay) as? NSNumber
            guard let _number = number else { return false }
            return _number.boolValue
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.didDisplay, NSNumber(value: newValue as Bool), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public private(set) var isViewWillDisplay: Bool {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.willDisplay) as? NSNumber
            guard let _number = number else { return false }
            return _number.boolValue
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.willDisplay, NSNumber(value: newValue as Bool), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open class func swizzling() {
        struct Static {
            static var token = false
        }
        
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }
        
        guard !Static.token else { return }
        Static.token = true
        
        let originalSelector = #selector(viewDidLayoutSubviews)
        let swizzledSelector = #selector(sif_viewDidLayoutSubviews)
        
        self.swizzledMethod(self, originalSelector: originalSelector, to: swizzledSelector)
        
        let originalSelector3 = #selector(viewWillAppear(_:))
        let swizzledSelector3 = #selector(sif_viewWillAppear(_:))
        
        self.swizzledMethod(self, originalSelector: originalSelector3, to: swizzledSelector3)
        
        let originalSelector4 = #selector(viewDidAppear(_:))
        let swizzledSelector4 = #selector(sif_viewDidAppear(_:))
        
        self.swizzledMethod(self, originalSelector: originalSelector4, to: swizzledSelector4)
        
        let originalSelector5 = #selector(viewDidDisappear(_:))
        let swizzledSelector5 = #selector(sif_viewDidDisappear(_:))
        
        self.swizzledMethod(self, originalSelector: originalSelector5, to: swizzledSelector5)
    }
    
    @objc func sif_viewDidLayoutSubviews() {
        let originalSelector = #selector(viewDidLayoutSubviews)
        let swizzledSelector = #selector(sif_viewDidLayoutSubviews)

        type(of: self).exchangeMethod(originalSelector: swizzledSelector, to: originalSelector)
        viewDidLayoutSubviews()
        type(of: self).exchangeMethod(originalSelector: originalSelector, to: swizzledSelector)
        
        if self.isViewLayoutFinished == false {
            self.isViewLayoutFinished = true
            self.viewDidFinishInitialLayout()
        } else {
            self.viewDidFinishRefreshLayout()
        }
    }
    
    @objc func sif_viewWillAppear(_ animated: Bool) {
        let originalSelector = #selector(viewWillAppear(_:))
        let swizzledSelector = #selector(sif_viewWillAppear(_:))

        type(of: self).exchangeMethod(originalSelector: swizzledSelector, to: originalSelector)
        viewWillAppear(animated)
        type(of: self).exchangeMethod(originalSelector: originalSelector, to: swizzledSelector)
        
        if self.isViewWillDisplay == false {
            self.isViewWillDisplay = true
            self.viewWillDisplay()
        } else {
            self.viewWillResume()
        }
    }
    
    @objc func sif_viewDidAppear(_ animated: Bool) {
        let originalSelector = #selector(viewDidAppear(_:))
        let swizzledSelector = #selector(sif_viewDidAppear(_:))
        
        type(of: self).exchangeMethod(originalSelector: swizzledSelector, to: originalSelector)
        viewDidAppear(animated)
        type(of: self).exchangeMethod(originalSelector: originalSelector, to: swizzledSelector)
        
        if self.isViewDidDisplay == false {
            self.isViewDidDisplay = true
            self.viewDidDisplay()
        } else {
            self.viewDidResume()
        }
    }
    
    @objc func sif_viewDidDisappear(_ animated: Bool) {
        let originalSelector = #selector(viewDidDisappear(_:))
        let swizzledSelector = #selector(sif_viewDidDisappear(_:))

        type(of: self).exchangeMethod(originalSelector: swizzledSelector, to: originalSelector)
        viewDidDisappear(animated)
        type(of: self).exchangeMethod(originalSelector: originalSelector, to: swizzledSelector)
        
        if self.isMovingFromParent {
            didRemoveFromParent()
        }
    }
}

// Addtional methods
extension UIViewController {
    @objc open func viewDidFinishInitialLayout() {}
    @objc open func viewDidFinishRefreshLayout() {}
    
    @objc open func viewWillDisplay() {}
    @objc open func viewWillResume() {}
    
    @objc open func viewDidDisplay() {}
    @objc open func viewDidResume() {}
    
    @objc open func didRemoveFromParent() {}
}
