//
//  UIStoryboard+Additional.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/25/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    func instantiateViewController<T: UIViewController>(identifier: String) -> T? {
        return self.instantiateViewController(withIdentifier: identifier) as? T
    }
    
    func instantiateViewController <T: UIViewController>(withIdentifer: String, type: T.Type) -> T? {
        return self.instantiateViewController(withIdentifier: withIdentifer) as? T
    }
}
