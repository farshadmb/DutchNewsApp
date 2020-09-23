//
//  UIView+Nib.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    class func fromNib(nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil: nibNameOrNil, type: self)
    }
    
    class func fromNib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let view: T? = fromNib(nibNameOrNil: nibNameOrNil, type: T.self)
        return view!
    }
    
    class func fromNib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = String(describing: T.self)
        }
        
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        
        nibViews?.forEach({ (nibView) in
            if let tog = nibView as? T {
                view = tog
            }
        })
        
        return view
    }
    
}

extension UIView {
    
    class func nib(nibNameOrNil: String? = nil) -> UINib {
        return nib(nibNameOrNil: nibNameOrNil, type: self)
    }
    
    class func nib<T: UIView>(nibNameOrNil: String? = nil, type: T.Type) -> UINib {
        
        let name: String
        
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = String(describing: type)
        }
        
        let bundle = Bundle(for: type)
        
        return UINib(nibName: name, bundle: bundle)
    }
}
