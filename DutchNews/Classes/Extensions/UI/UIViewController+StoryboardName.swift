//
//  UIViewController+StoryboardName.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class var className: String {
        return String(describing: self)
    }
    
}
