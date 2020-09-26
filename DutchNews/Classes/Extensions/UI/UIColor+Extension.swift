//
//  UIColor+String.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    
    convenience init?(hexString: String?) {
        
        guard hexString != nil else {
            return nil
        }
        
        let scanner = Scanner(string: hexString!)
        scanner.scanLocation = 1
        
        var rgbValue: UInt64 = 0
        
        if scanner.scanHexInt64(&rgbValue) {
        
            self.init(rgb: rgbValue)
        }else {
            return nil
        }
        
    }
    
    convenience init(rgb rgbValue: UInt64 = 0) {
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)
        let green = CGFloat((rgbValue & 0xFF00) >> 8)
        let blue = CGFloat(rgbValue & 0xFF)
        
        self.init(
            red: red / 255.0,
            green: green / 255.0,
            blue: blue / 255.0,
            alpha: 1
        )
        
    }
    
    static func transactionColor(for type: Int) -> UIColor {
        
        let color: UIColor
        
        switch type {
        case 1, 3:
            color = UIColor(rgb: 0x004f80)
            
        default:
            color = UIColor(rgb: 0xd2a645)
        }
        
        return color
    }
    
    static func discountColor(for discountValue: Int) -> UIColor {
        
        let discountColor: UIColor
        
        switch discountValue {
        case 1..<20:
            discountColor = UIColor(rgb: 0x13b878)
            
        case 20..<40:
            discountColor = UIColor(rgb: 0x276aae)
            
        case 40..<60:
            discountColor = UIColor(rgb: 0x673ab7)
            
        case 60..<80:
            discountColor = UIColor(rgb: 0xe91e63)
            
        case 80..<100:
            discountColor = UIColor(rgb: 0xf44336)
            
        default:
            discountColor = .clear
            
        }
        return discountColor
    }
    
    var hexString: String {
        
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0
            
            return String(format: "#%06x", rgb)
        
    }
    
    var hexAlphaString: String {
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgba: Int = (Int)(red * 255) << 32 | (Int)(green * 255) << 16 | (Int)(blue * 255) << 8 | (Int)(alpha * 255) << 0
        
        return String(format: "#%08x", rgba)
        
    }
    
}
