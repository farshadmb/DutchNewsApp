//
//  APIServerResponseStatus.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

enum APIServerResponseStatus: String, Codable {
    
    case success = "ok"
    case failure = "error"
    
}
