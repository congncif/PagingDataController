//
//  EdgeLineView.swift
//  SiFUtilities
//
//  Created by FOLY on 11/7/18.
//  Copyright © 2018 [iF] Solution. All rights reserved.
//

import CoreGraphics
import UIKit

@IBDesignable
open class EdgeLineView: UIView {
    @IBInspectable public var lineColor: UIColor = .lightGray
    @IBInspectable public var lineWidth: CGFloat = 0.5
    
    @IBInspectable public var leftLine: Bool = false
    @IBInspectable public var rightLine: Bool = false
    @IBInspectable public var bottomLine: Bool = false
    @IBInspectable public var topLine: Bool = false
    
    @IBInspectable public var leftSpace: CGFloat = 0
    @IBInspectable public var rightSpace: CGFloat = 0
    @IBInspectable public var bottomSpace: CGFloat = 0
    @IBInspectable public var topSpace: CGFloat = 0
    
    @IBInspectable public var dashPatterns: String = ""
    
    public var dashes: [CGFloat] {
        let values = dashPatterns
        
        guard !values.isEmpty else {
            return []
        }
        
        let patterns = values.components(separatedBy: ",")
        return patterns.map { (item) -> CGFloat in
            if let number = NumberFormatter().number(from: item) {
                return CGFloat(exactly: number) ?? 0
            }
            return 0
        }
    }
    
    func calculatePoints(in rect: CGRect) -> [(start: CGPoint, end: CGPoint)] {
        var points: [(start: CGPoint, end: CGPoint)] = []
        if leftLine {
            let startPoint = CGPoint(x: 0, y: topSpace)
            let endPoint = CGPoint(x: 0, y: rect.height - bottomSpace)
            points.append((start: startPoint, end: endPoint))
        }
        
        if rightLine {
            let x = rect.width - lineWidth
            let startPoint = CGPoint(x: x, y: topSpace)
            let endPoint = CGPoint(x: x, y: rect.height - bottomSpace)
            points.append((start: startPoint, end: endPoint))
        }
        
        if bottomLine {
            let y = rect.height - lineWidth
            let startPoint = CGPoint(x: leftSpace, y: y)
            let endPoint = CGPoint(x: rect.width - rightSpace, y: y)
            points.append((start: startPoint, end: endPoint))
        }
        
        if topLine {
            let startPoint = CGPoint(x: leftSpace, y: 0)
            let endPoint = CGPoint(x: rect.width - rightSpace, y: 0)
            points.append((start: startPoint, end: endPoint))
        }
        
        return points
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        for point in calculatePoints(in: rect) {
            context.move(to: point.start)
            context.addLine(to: point.end)
        }
        
        
        if dashes.count > 0 {
            context.setLineDash(phase: 0, lengths: dashes)
        }
        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        context.setLineCap(.round)
        
        context.strokePath()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setNeedsDisplay()
    }
}
