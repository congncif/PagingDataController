//
//  UINavigationBar.swift
//  Pods-SiFUtilities_Example
//
//  Created by FOLY on 4/6/18.
//

import CoreGraphics
import Foundation
import UIKit

extension UINavigationBar {
    public func transparent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
    }

    public func opaque() {
        shadowImage = nil
        setBackgroundImage(nil, for: .default)
    }
}

public struct GradientComponents {
    public var colors: [UIColor]
    public var locations: [Double]
    public var startPoint: CGPoint
    public var endPoint: CGPoint

    var cgColors: [CGColor] {
        return colors.map { $0.cgColor }
    }

    var locationNumbers: [NSNumber] {
        return locations.map { NSNumber(value: $0) }
    }

    public init(colors: [UIColor], locations: [Double], startPoint: CGPoint, endPoint: CGPoint) {
        self.colors = colors
        self.locations = locations
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

extension UINavigationBar {
    public func setBarGradientColor(with components: GradientComponents) {
        let size = CGSize(width: UIScreen.main.bounds.size.width, height: 1)
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        gradient.colors = components.cgColors
        gradient.locations = components.locationNumbers
        gradient.startPoint = components.startPoint
        gradient.endPoint = components.endPoint

        UIGraphicsBeginImageContext(gradient.bounds.size)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        gradient.render(in: context)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        guard let image = gradientImage else { return }

        barTintColor = UIColor(patternImage: image)
    }
}

extension UINavigationBar {
    public func setBackImage(_ image: UIImage) {
        backIndicatorImage = image
        backIndicatorTransitionMaskImage = image
    }

    public func setHighlightColor(_ color: UIColor) {
        tintColor = color

        var currentAttributes = titleTextAttributes ?? [:]
        currentAttributes[.foregroundColor] = color
        titleTextAttributes = currentAttributes
    }
}
