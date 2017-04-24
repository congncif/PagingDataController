//
//  UIViewController+Storyboard.swift
//  SiFUtilities
//
//  Created by FOLY on 1/11/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation
import UIKit

enum StoryboardName: String {
    case main = "Main"
}

public extension UIStoryboard {
    public var main: UIStoryboard {
        return UIStoryboard(name: StoryboardName.main.rawValue, bundle: nil)
    }
    
    public convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }
}

public extension UIViewController {
    
    fileprivate class func instantiateFromStoryboardHelper<T>(storyboardName: String,
                                                           storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(storyboardName: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName)
        let controller = storyboard.instantiateInitialViewController() as! T
        return controller
    }
    
    public class func instantiateFromStoryboard(name: String,
                                                identifier: String) -> Self {
        return instantiateFromStoryboardHelper(storyboardName: name , storyboardId: identifier)
    }
    
    public class func instantiateFromStoryboard(name: String) -> Self {
        let identifier = className
        return instantiateFromStoryboardHelper(storyboardName: name , storyboardId: identifier)
    }
    
    public class func instantiateFromStoryboard() -> Self {
        let name = className
        let identifier = className
        return instantiateFromStoryboardHelper(storyboardName: name , storyboardId: identifier)
    }
    
    public class func instantiateFromMainStoryboard(identifier: String) -> Self {
        return instantiateFromStoryboard(name: StoryboardName.main.rawValue, identifier: identifier)
    }
    
    public class func instantiateFromMainStoryboard() -> Self {
        let identifier = className
        return instantiateFromStoryboard(name: StoryboardName.main.rawValue, identifier: identifier)
    }
    
    public class func instantiateInitialFromStoryboard(name: String) -> Self {
        return instantiateFromStoryboardHelper(storyboardName: name)
    }
    
    public class func instantiateInitialFromStoryboard() -> Self {
        let name = className
        return instantiateFromStoryboardHelper(storyboardName: name)
    }
    
    public func navigationContainer<U: UINavigationController>() -> U? {
        return self.navigationController as? U
    }
    
    public func tabBarContainer<U: UITabBarController>() -> U? {
        return self.tabBarController as? U
    }
    
    /**
     Init with storyboard path
     
     - parameter storyboardPath: <storyboard file name>.<storyboard identifier>
     
     - returns: instance of this class
     */
    public class func instantiateViewController(storyboardPath: String) -> Self {
        let components = (storyboardPath as NSString).components(separatedBy: ".")
        
        guard components.count > 0 && components.count < 3 else { return self.init() }
        
        if components.count == 1 {
            return instantiateFromMainStoryboard(identifier: storyboardPath)
        }else {
            let storyboardName = components.first
            let storyboardId = components.last
            
            return instantiateFromStoryboardHelper(storyboardName: storyboardName!,
                                                   storyboardId: storyboardId!)
        }
    }
}
