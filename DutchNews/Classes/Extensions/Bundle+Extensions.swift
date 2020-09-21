//
//  Bundle+Extensions.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

extension Bundle {
    
    var releaseVersionNumber: String? {
        return self.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    var buildVersionNumber: String? {
        return self.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
}
