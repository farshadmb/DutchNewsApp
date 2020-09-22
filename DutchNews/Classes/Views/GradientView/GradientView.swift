//
//  GradientView.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/22/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {
 
    open override class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        // swiftlint:disable:next force_cast
        return self.layer as! CAGradientLayer
    }
    
    @IBInspectable
    var topColor: UIColor? = .white {
        didSet {
            self.updateGradiant(colors: (top: topColor, bottom: bottomColor))
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var bottomColor: UIColor? = .gray {
        
        didSet {
            self.updateGradiant(colors: (top: topColor, bottom: bottomColor))
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var startPoint: CGPoint = .zero {
        didSet {
            self.gradientLayer.startPoint = startPoint
            self.setNeedsDisplay()
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var endPoint: CGPoint = .zero {
        didSet {
            self.gradientLayer.endPoint = endPoint
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var startLocation: Float = 0.0 {
        didSet {
           self.update(locations: [self.startLocation, endLocation])
        }
    }
    
    @IBInspectable
    var endLocation: Float = 1.0 {
        didSet {
            
            self.update(locations: [self.startLocation, endLocation])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
//        self.commonInit()
        super.prepareForInterfaceBuilder()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.gradientLayer.frame = self.bounds
    }
    
    private func commonInit() {
        
        self.gradientLayer.startPoint = startPoint
        self.gradientLayer.endPoint = endPoint
        self.update(locations: [self.startLocation, self.endLocation])
        self.updateGradiant(colors: (top: topColor, bottom: bottomColor))
        
    }
    
    private func updateGradiant(colors : (top: UIColor?, bottom: UIColor?)) {
        
        switch colors {
        case (.some(let up), .some(let down)):
            self.setGradientColor(colors: [up, down])
            break
        case (.some(let color), .none),
             (.none, .some(let color)):
            self.setGradientColor(colors: [color])
            break
            
        default:
            self.self.setGradientColor(colors: nil)
        }
        
    }
    
    private func setGradientColor(colors: [UIColor]?) {
        self.gradientLayer.colors = colors?.map { $0.cgColor }
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    
    private func update(locations: [Float]) {
        self.gradientLayer.locations = locations.map { NSNumber(value: $0) }
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    
}
