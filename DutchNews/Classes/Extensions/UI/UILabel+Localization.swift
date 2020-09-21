//
//  UILabel+Localization.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    // swiftlint:disable:next empty_first_line
    private struct AssociatedKey {
        static var localizedStringKey = "localizedStringKey"
    }
    
    /// <#Description#>
    @IBInspectable
    var localizedText: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.localizedStringKey) as? String
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.localizedStringKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            guard let value = newValue else {
                return
            }
            self.text = NSLocalizedString(value, comment: "")
        }
    }
    
}
