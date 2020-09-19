//
//  SearchNewsRepository.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import Alamofire

/// SearchNewsRepository
final class SearchNewsRepository: WebRepository {
    
    let networkService: NetworkServiceInterceptable
    
    init(networkService: NetworkServiceInterceptable, authenticator: RequestInterceptor) {
        self.networkService = networkService
        self.networkService.addingRequest(interceptor: authenticator)
    }
    
}
