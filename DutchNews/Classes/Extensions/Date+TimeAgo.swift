//
//  Date+TimeAgo.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

private struct DateComponentUnitFormatter {
    
    private struct DateComponentUnitFormat {
        let unit: Calendar.Component
        
        let singularUnit: String
        let pluralUnit: String
        
        let futureSingular: String
        let pastSingular: String
    }
    
    private let formats: [DateComponentUnitFormat] = [
        
        DateComponentUnitFormat(unit: .year,
                                singularUnit: NSLocalizedString("year", comment: ""),
                                pluralUnit: NSLocalizedString("years", comment: ""),
                                futureSingular: NSLocalizedString("next-year", comment: ""),
                                pastSingular: NSLocalizedString("last-year", comment: "")),
        
        DateComponentUnitFormat(unit: .month,
                                singularUnit: NSLocalizedString("month", comment: ""),
                                pluralUnit: NSLocalizedString("months", comment: ""),
                                futureSingular: NSLocalizedString("next-month", comment: ""),
                                pastSingular: NSLocalizedString("last-month", comment: "")),
        
        DateComponentUnitFormat(unit: .weekOfYear,
                                singularUnit: NSLocalizedString("week", comment: ""),
                                pluralUnit: NSLocalizedString("weeks", comment: ""),
                                futureSingular: NSLocalizedString("next-week", comment: ""),
                                pastSingular: NSLocalizedString("last-week", comment: "")),
        
        DateComponentUnitFormat(unit: .day,
                                singularUnit: NSLocalizedString("day", comment: ""),
                                pluralUnit: NSLocalizedString("days", comment: ""),
                                futureSingular: NSLocalizedString("Tomorrow", comment: ""),
                                pastSingular: NSLocalizedString("Yesterday", comment: "")),
        
        DateComponentUnitFormat(unit: .hour,
                                singularUnit: NSLocalizedString("hour", comment: ""),
                                pluralUnit: NSLocalizedString("hours", comment: ""),
                                futureSingular: NSLocalizedString("In-an-hour", comment: ""),
                                pastSingular: NSLocalizedString("An hour ago", comment: "")),
        
        DateComponentUnitFormat(unit: .minute,
                                singularUnit: NSLocalizedString("minute", comment: ""),
                                pluralUnit: NSLocalizedString("minutes", comment: ""),
                                futureSingular: NSLocalizedString("In a minute", comment: ""),
                                pastSingular: NSLocalizedString("A minute ago", comment: "")),
        
        DateComponentUnitFormat(unit: .second,
                                singularUnit: NSLocalizedString("second", comment: ""),
                                pluralUnit: NSLocalizedString("seconds", comment: ""),
                                futureSingular: NSLocalizedString("just-now", comment: ""),
                                pastSingular: NSLocalizedString("just-now", comment: ""))
        
        ]
    
    func string(forDateComponents dateComponents: DateComponents, useNumericDates: Bool) -> String {
        for format in self.formats {
            let unitValue: Int
            
            switch format.unit {
            case .year:
                unitValue = dateComponents.year ?? 0
            case .month:
                unitValue = dateComponents.month ?? 0
            case .weekOfYear:
                unitValue = dateComponents.weekOfYear ?? 0
            case .day:
                unitValue = dateComponents.day ?? 0
            case .hour:
                unitValue = dateComponents.hour ?? 0
            case .minute:
                unitValue = dateComponents.minute ?? 0
            case .second:
                unitValue = dateComponents.second ?? 0
            default:
                assertionFailure("Date does not have requried components")
                return ""
            }
            
            switch unitValue {
            case 2 ..< Int.max:
                return "\(unitValue) \(format.pluralUnit) \(NSLocalizedString("ago", comment: ""))"
            case 1:
                return useNumericDates ? "\(unitValue) \(format.singularUnit) \(NSLocalizedString("ago", comment: ""))" : format.pastSingular
            case -1:
                return useNumericDates ? "In \(-unitValue) \(format.singularUnit)" : format.futureSingular
            case Int.min ..< -1:
                return "\(NSLocalizedString("In", comment: "")) \(-unitValue) \(format.pluralUnit)"
            default:
                break
            }
        }
        
        return (NSLocalizedString("just-now", comment: ""))
    }
}

extension Date {
    
    func timeAgoSinceNow(useNumericDates: Bool = false) -> String {
        
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let components = calendar.dateComponents(unitFlags, from: self, to: now)
        
        let formatter = DateComponentUnitFormatter()
        return formatter.string(forDateComponents: components, useNumericDates: useNumericDates)
    }
}
