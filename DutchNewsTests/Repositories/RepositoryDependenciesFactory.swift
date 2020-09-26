//
//  RepositoryDependenciesFactory.swift
//  DutchNewsTests
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import Alamofire
import Mocker

@testable import DutchNews

struct RepositoryDependenciesFactory {
    
    static func createMockAPIClient() -> NetworkServiceInterceptable {
        
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return APIClientService(baseURL: AppConfig.BaseURL,
                                session: sessionManager, decoder: decoder)
    }
    
    static func createAPIClient() -> NetworkServiceInterceptable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return APIClientService(baseURL: AppConfig.BaseURL, decoder: decoder)
    }
    
    static func createAuthentictor() -> RequestInterceptor {
        return APIAuthenticator(token: AppConfig.APIKey)
    }
    
     static func createValidator() -> NetworkValidResponse {
        return MockArticleValidResponse()
    }
    
    static func createStorage() -> Storage {
        return CodableDataManager.default
    }
    
}
