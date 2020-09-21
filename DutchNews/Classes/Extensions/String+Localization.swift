//
//  String+Localization.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
          return localized(withComment: "")
    }
    
    func localized(withComment: String) -> String {
           return NSLocalizedString(self,
                                    tableName: nil,
                                    bundle: Bundle.main,
                                    value: "", comment: withComment)
    }
    
}
