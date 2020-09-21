//
//  String+EmptyChecking.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

// swiftlint:disable empty_first_line

protocol OptionalString {}

extension String: OptionalString {}
// swiftlint:enable empty_first_line

extension Optional where Wrapped: OptionalString {
    
    var isEmptyOrBlank: Bool {
        return String.isEmptyOrBlankString(self as? String)
    }
    
}

extension String {
    
    func toBool() -> Bool? {
        return NSString(string: self).boolValue
    }
    
    static func isEmptyOrBlankString(_ aString: String?) -> Bool {
        
        if aString == nil {
            return true
        }
        
        if aString!.isEmpty {
            return true
        }
        
        if aString!.trimmingCharacters(in: CharacterSet.whitespaces).count == 0 {
            return true
        }
        if aString!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            return true
        }
        
        return false
    }
    
    var isEmptyOrBlank: Bool {
        return String.isEmptyOrBlankString(self)
    }
    
}

// swiftlint:disable all
