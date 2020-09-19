//
//  WebRepository.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import Alamofire

/// The `WebRepository` Abstract
protocol WebRepository {
    
    /// <#Description#>
    /// - Parameters:
    ///   - networkService: <#networkService description#>
    ///   - authenticator: <#authenticator description#>
    init(networkService: NetworkServiceInterceptable, authenticator: RequestInterceptor)
    
}
