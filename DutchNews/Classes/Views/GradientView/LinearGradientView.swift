//
//  LinearGradientView.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/22/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

class LinearGradientLayer: CALayer {
    
    /// <#Description#>
    ///
    /// - vertical: <#vertical description#>
    /// - horizontal: <#horizontal description#>
    /// - custom: <#custom description#>
    /// - let.custom:: <#let.custom: description#>
    enum Direction {
        case vertical
        case horizontal
        case custom(start: CGPoint, end: CGPoint)
        
        var points: (start: CGPoint, end: CGPoint) {
            switch self {
            case .vertical:
                return (CGPoint(x: 0.5, y: 0.0), CGPoint(x: 0.5, y: 1.0))
            case .horizontal:
                return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
            case let .custom(start, end):
                return (start, end)
            }
        }
    }
    
    var direction: Direction = .vertical
    
    var colorSpace = CGColorSpaceCreateDeviceRGB()
    var colors: [CGColor]?
    var locations: [CGFloat]?
    
    /// <#Description#>
    var options = CGGradientDrawingOptions(rawValue: 0)
    
    // MARK: - Lifecycle
    
    /// <#Description#>
    required override init() {
        super.init()
        masksToBounds = true
        needsDisplayOnBoundsChange = true
    }
    
    /// <#Description#>
    ///
    /// - Parameter aDecoder: <#aDecoder description#>
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// <#Description#>
    ///
    /// - Parameter layer: <#layer description#>
    required override init(layer: Any) {
        super.init(layer: layer)
    }
    
    /// <#Description#>
    ///
    /// - Parameter ctx: <#ctx description#>
    override func draw(in ctx: CGContext) {
        ctx.saveGState()
        
        guard let colors = colors, let gradient = CGGradient(colorsSpace: colorSpace,
                                                             colors: colors as CFArray, locations: locations) else { return }
        
        let points = direction.points
        ctx.drawLinearGradient(
            gradient,
            start: transform(points.start),
            end: transform(points.end),
            options: options
        )
    }
    
    // MARK: - Private
    
    /// <#Description#>
    ///
    /// - Parameter point: <#point description#>
    /// - Returns: <#return value description#>
    private func transform(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: bounds.width * point.x, y: bounds.height * point.y)
    }
}

/// <#Description#>
class LinearGradientView: UIView {
    
    /// <#Description#>
    lazy var gradientLayer = layer as? LinearGradientLayer
    
    /// <#Description#>
    override class var layerClass: AnyClass {
        return LinearGradientLayer.self
    }
    
    /// <#Description#>
    var direction: LinearGradientLayer.Direction = .vertical {
        didSet {
            updateGradient(with: direction, colors: colors)
        }
    }
    
    /// <#Description#>
    var colors: [UIColor] = [UIColor.white, UIColor.blue] {
        didSet {
            guard colors != oldValue else {
                return
            }
            updateGradient(with: direction, colors: colors)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - direction: <#direction description#>
    ///   - colors: <#colors description#>
    func updateGradient(with direction: LinearGradientLayer.Direction, colors: UIColor...) {
        gradientLayer?.direction = direction
        gradientLayer?.colors = colors.compactMap { color in
            color.cgColor
        }
    }
    
    func updateGradient(with direction: LinearGradientLayer.Direction, colors: [UIColor]) {
        gradientLayer?.direction = direction
        gradientLayer?.colors = colors.compactMap { color in
            color.cgColor
        }
    }
    
    private func commonInit() {
        updateGradient(with: direction, colors: colors)
    }
    
}
