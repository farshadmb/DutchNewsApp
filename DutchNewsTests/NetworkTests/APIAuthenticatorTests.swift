//
//  APIAuthenticatorTests.swift
//  DutchNewsTests
//
//  Created by Farshad Mousalou on 9/19/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import XCTest
import Foundation
import UIKit
import Mocker
import Alamofire
@testable import DutchNews

class APIAuthenticatorTests: XCTestCase {
    
    var networkService: NetworkServiceInterceptable!
    
    override func setUp() {
        
        networkService = APIClientService(baseURL: URL(string: "https://newsapi.org/")!)
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        networkService = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testUnauthenticatedRequest() {
        
        let expectations = self.expectation(description: "UnaunthenticatedRequest")
        
        _ = networkService.executeRequest(endpoint: "v2/top-headlines",
                                          parameters: ["country": "nl"],
                                          method: .get,
                                          headers: [:],
                                          validator: nil,
                                          completion: { (result: Result<Empty, Error>) in
                                            switch result {
                                            case .success(let value):
                                                print(value)
                                                XCTFail("Server must return unauthorized error with status code 401")
                                            case .failure(let error):
                                                print("Response Error => ",error, "localized Info: ",error.localizedDescription)
                                            }
                                            
                                            expectations.fulfill()
        })
        
        self.waitForExpectations(timeout: 30.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }
    
    func testEmptyAPIKeyAuthenticationRequest() {
        
        let expectations = self.expectation(description: "EmptyAPIKeyAuthentication")
        let authenticator: RequestInterceptor = APIAuthenticator(token: "")
        
        networkService.addingRequest(interceptor: authenticator)
        
        _ = networkService.executeRequest(endpoint: "v2/top-headlines",
                                          parameters: ["country": "nl"],
                                          method: .get,
                                          headers: [:],
                                          validator: nil,
                                          completion: { (result: Result<Empty, Error>) in
                                            switch result {
                                                
                                            case .success(let value):
                                                print(value)
                                                XCTFail("Server must return unauthorized error with status code 401")
                                            case .failure(let error):
                                                print("Response Error => ",error, "localized Info: ",error.localizedDescription)
                                            }
                                            
                                            expectations.fulfill()
        })
        
        self.waitForExpectations(timeout: 30.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }
    
    func testAuthenticationSuccessfullRequest() {
        
        let expectations = self.expectation(description: "AuthenticationSuccessfull")
        let authenticator: RequestInterceptor = APIAuthenticator(token: AppConfig.APIKey)
        
        networkService.addingRequest(interceptor: authenticator)
        
        _ = networkService.executeRequest(endpoint: "v2/top-headlines",
                                          parameters: ["country": "nl"],
                                          method: .get,
                                          headers: [:],
                                          validator: nil,
                                          completion: { (result: Result<Empty, Error>) in
                                            switch result {
                                            case .success(let value):
                                                print(value)
                                            case .failure(let error):
                                                 XCTFail("Response Error => \(error), localized Info: \(error.localizedDescription)")
                                            }
                                            
                                            expectations.fulfill()
        })
        
        self.waitForExpectations(timeout: 30.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }
}
