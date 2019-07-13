//
//  UIView+Animation.swift
//  Pods-SiFUtilities_Example
//
//  Created by FOLY on 2/6/18.
//

import Foundation
import UIKit

extension UIView {
    public func animate(duration: Double = 0.25,
                        transitionType: CATransitionType = .moveIn,
                        direction: CATransitionSubtype = .fromLeft,
                        key: String = String()) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = transitionType
        transition.subtype = direction
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.isRemovedOnCompletion = true
        layer.add(transition, forKey: key)
    }
    
    public func fade(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .fade, direction: .fromLeft)
    }
    
    public func moveInFromLeft(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .moveIn, direction: .fromLeft)
    }
    
    public func moveInFromRight(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .moveIn, direction: .fromRight)
    }
    
    public func moveInFromTop(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .moveIn, direction: .fromTop)
    }
    
    public func moveInFromBottom(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .moveIn, direction: .fromBottom)
    }
    
    public func pushFromLeft(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .push, direction: .fromLeft)
    }
    
    public func pushFromRight(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .push, direction: .fromRight)
    }
    
    public func pushFromTop(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .push, direction: .fromTop)
    }
    
    public func pushFromBottom(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .push, direction: .fromBottom)
    }
    
    public func revealFromLeft(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .reveal, direction: .fromLeft)
    }
    
    public func revealFromRight(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .reveal, direction: .fromRight)
    }
    
    public func revealFromTop(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .reveal, direction: .fromTop)
    }
    
    public func revealFromBottom(_ duration: Double = 0.25) {
        animate(duration: duration, transitionType: .reveal, direction: .fromBottom)
    }
}
