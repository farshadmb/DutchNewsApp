//
//  NetworkValidResponse.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import Alamofire

/// NetworkValidResponse Abstract
protocol NetworkValidResponse {
    
    var statusCodes: Set<Int> { get }
    var contentTypes: [String] { get }
}

extension NetworkValidResponse {
    var statusCodes: Set<Int> { Set(200..<300) }
    var contentTypes: [String] { ["*/*" ] }
}
