//
//  Date+PersianConvertor.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    static var today: Date {
        return Date()
    }
    
    static var now: Date {
        return today
    }
    
}

extension DateFormatter {
        
    static let standardFormatter: DateFormatter = {
        
        let calendar = Calendar.current
        let locale = NSLocale.system
        
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.calendar = calendar
        formatter.timeZone = NSTimeZone.system
        
        return formatter
    }()
    
    static func currentZoneFormatter() -> DateFormatter {
        let calendar = Calendar.current
        let locale = Locale.current
        
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.calendar = calendar
        
        return formatter
    }
    
}
