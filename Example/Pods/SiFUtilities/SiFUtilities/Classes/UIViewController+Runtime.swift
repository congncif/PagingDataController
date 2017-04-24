//
//  UIExtensions.swift
//  PagingDataController
//
//  Created by FOLY on 5/28/16.
//  Copyright © 2016 FOLY. All rights reserved.
//

import Foundation


@IBDesignable extension UIViewController {
    
    //MARK: - Runtime properties
    
    fileprivate struct AssociatedKeys {
        static var LayoutDidFinished = false
        static var DidDisplay = false
        static var StatusBarStyle = 0
        static var StatusBarHidden = false
    }
    
    public private(set) var layoutDidFinished: Bool {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.LayoutDidFinished) as? NSNumber
            guard number != nil else { return false }
            return number!.boolValue
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.LayoutDidFinished,
                NSNumber(value: newValue as Bool),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    public private(set) var didDisplay: Bool {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.DidDisplay) as? NSNumber
            guard number != nil else { return false }
            return number!.boolValue
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.DidDisplay,
                NSNumber(value: newValue as Bool),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    public var statusBarStyle: UIStatusBarStyle {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.StatusBarStyle) as? NSNumber
            guard number != nil else { return UIStatusBarStyle.default }
            let style = UIStatusBarStyle(rawValue: number!.intValue)
            guard style != nil else { return UIStatusBarStyle.default }
            return style!
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.StatusBarStyle,
                NSNumber(value: newValue.rawValue as Int),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    @IBInspectable public var statusStyleRawValue: Int {
        get {
            return statusBarStyle.rawValue
        }
        set {
            statusBarStyle = UIStatusBarStyle(rawValue: newValue) ?? .default
        }
    }
    
    @IBInspectable public var statusBarHidden: Bool {
        get {
            let number = objc_getAssociatedObject(self, &AssociatedKeys.StatusBarHidden) as? NSNumber
            guard number != nil else { return false }
            return number!.boolValue
        }
        
        set {
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.StatusBarHidden,
                NSNumber(value: newValue as Bool),
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
    
    /*********************************************************************************/
    //MARK: -  Method Swizzling
    /*********************************************************************************/
    
    open override class func initialize() {
        struct Static {
            static var token = false
        }
        
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
        }
        
        guard !Static.token else {
            return
        }
        Static.token = true
        
        let originalSelector = #selector(viewDidLayoutSubviews)
        let swizzledSelector = #selector(sif_viewDidLayoutSubviews)
        
        swizzledMethod(self, originalSelector: originalSelector, to: swizzledSelector)
        
        let originalSelector1 = #selector(getter: prefersStatusBarHidden)
        let swizzledSelector1 = #selector(getter: sif_prefersStatusBarHidden)
        
        swizzledMethod(self, originalSelector: originalSelector1, to: swizzledSelector1)
        
        let originalSelector2 = #selector(getter: preferredStatusBarStyle)
        let swizzledSelector2 = #selector(getter: sif_preferredStatusBarStyle)
        
        swizzledMethod(self, originalSelector: originalSelector2, to: swizzledSelector2)
        
        let originalSelector3 = #selector(viewWillAppear(_:))
        let swizzledSelector3 = #selector(sif_viewWillAppear(_:))
        
        swizzledMethod(self, originalSelector: originalSelector3, to: swizzledSelector3)
        
        let originalSelector4 = #selector(viewDidAppear(_:))
        let swizzledSelector4 = #selector(sif_viewDidAppear(_:))
        
        swizzledMethod(self, originalSelector: originalSelector4, to: swizzledSelector4)
    }
    
    public class func swizzledMethod(_ cls: AnyClass!,
                                     originalSelector:Selector,
                                     to swizzledSelector: Selector) {
        
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        
        let didAddMethod = class_addMethod(cls,
                                           originalSelector,
                                           method_getImplementation(swizzledMethod),
                                           method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(cls,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func sif_viewDidLayoutSubviews() {
        if layoutDidFinished == false {
            layoutDidFinished = true
            self.viewDidFinishLayout()
        }
    }
    
    open func viewDidFinishLayout() {}
    open func viewDidDisplay() {}
    
    func sif_viewWillAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func sif_viewDidAppear(_ animated: Bool) {
        if didDisplay == false {
            didDisplay = true
            self.viewDidDisplay()
        }
    }
    
    var sif_prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    
    var sif_preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}



