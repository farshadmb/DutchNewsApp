//
//  Storable.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/24/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

/// Abstract `Storable`
/// The purpose of this abstract is to store and retreive Entities in Presistence Layer.
protocol Storable: Codable {
    
    func primaryKeyValue() -> String
    
}
