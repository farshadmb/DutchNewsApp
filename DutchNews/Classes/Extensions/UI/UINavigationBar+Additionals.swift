//
//  UINavigationBar+Additionals.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem {
    
    @IBInspectable
    var localizedTitle: String? {
        get {
            return nil
        }
        set {
            guard let newValue = newValue else { self.title = nil; return }
            self.title = NSLocalizedString(newValue, comment: "")
        }
    }
    
}
