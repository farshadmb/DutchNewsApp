//
//  APIClientServiceTests.swift
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

class APIClientServiceTests: XCTestCase {
    
    typealias DataDecoder = Alamofire.DataDecoder
    
    var networkService: NetworkService!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let sessionManager = Alamofire.Session(configuration: configuration)
        
        networkService = APIClientService(baseURL: URL(string: "https://domain.com/")!,
                                          session: sessionManager, decoder: JSONDecoder())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        networkService = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSimpleRequestResponse() {
        let expectedData = NetworkMockingDataFactory.createSimpleJSONData()
        
        let expectations = self.expectation(description: "SimpleRequestResponse")
        
        do {
            let mock = try NetworkMockBuilder(URL: "https://domain.com/api/user")
                .set(method: .get)
                .set(statusCode: 200)
                .set(data: [.get: expectedData])
                .set(contentType: .json)
                .build()
            
            Mocker.register(mock)
            
            _ = networkService.executeRequest(endpoint: "api/user",
                                              parameters: [:],
                                              method: .get,
                                              headers: [:],
                                              validator: nil,
                                              completion: { (result: Result<StubPerson, Error>) in
                                                switch result {
                                                case .success(let value):
                                                    print(value)
                                                case .failure(let error):
                                                    XCTFail(error.localizedDescription)
                                                }
                                                
                                                expectations.fulfill()
            })
            
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        
        self.waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }
    
    func testSimpleResponseContentTypeErrorHandling() {
        
        let expectedData = NetworkMockingDataFactory.createSimpleJSONData()
        let expectations = self.expectation(description: "SimpleResponseContentType")
        
        do {
            let mock = try NetworkMockBuilder(URL: "https://domain.com/api/user")
                .set(method: .get)
                .set(contentType: .html)
                .set(statusCode: 200)
                .set(data: [.get: expectedData])
                .build()
            
            Mocker.register(mock)
            
            _ = networkService.executeRequest(endpoint: "/api/user",
                                              parameters: [:],
                                              method: .get,
                                              headers: ["Accept": "application/json"],
                                              validator: nil,
                                              completion: { ( result: Result<StubPerson, Error>) in
                                                print("result => ", result)
                                                switch result {
                                                case .success:
                                                    XCTFail("SimpleResponse should not have a value response")
                                                case .failure(let error):
                                                    print("Error Occured ",error.localizedDescription)
                                                }
                                                expectations.fulfill()
            })
            
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        
        self.waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }
    
    func testSimpleResponseStatusCodeError() {
        
        let expectations = self.expectation(description: "SimpleResponseStatusCode")
        
        do {
            let mock = try NetworkMockBuilder(URL: "https://domain.com/api/user")
                .set(method: .get)
                .set(statusCode: 400)
                .set(data: [.get: "".data(using: .utf8)!])
                .set(contentType: .json)
                .build()
            
            Mocker.register(mock)
            
            _ = networkService.executeRequest(endpoint: "api/user",
                                              parameters: [:],
                                              method: .get,
                                              headers: [:],
                                              validator: nil,
                                              completion: { (result: Result<StubPerson, Error>) in
                                                switch result {
                                                case .success:
                                                    XCTFail("SimpleResponse should not have a value response")
                                                case .failure(let error):
                                                    print("Error Occured ",error.localizedDescription)
                                                }
                                                
                                                expectations.fulfill()
            })
            
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        
        self.waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }
    
    func testRequestWithEmptyResponse() {
        
        let expectations = self.expectation(description: "EmptyRequestResponse")
        
        do {
            let mock = try NetworkMockBuilder(URL: "https://domain.com/api/user")
                .set(method: .get)
                .set(statusCode: 204)
                .set(data: [.head: "".data(using: .utf8)!])
                .set(contentType: .json)
                .build()
            
            Mocker.register(mock)
            
            _ = networkService.executeRequest(endpoint: "api/user",
                                              parameters: [:],
                                              method: .head,
                                              headers: [:],
                                              validator: nil,
                                              completion: { (result: Result<StubPerson, Error>) in
                                                switch result {
                                                case .success:
                                                    XCTFail("The response should had a value.")
                                                case .failure(let error):
                                                    print("error descripition :",error,error.localizedDescription)
                                                }
                                                
                                                expectations.fulfill()
            })
            
        } catch let error {
            XCTFail(error.localizedDescription)
        }
        
        self.waitForExpectations(timeout: 10.0) { (error) in
            XCTAssertNil(error, "error occured \(error!)")
        }
    }
    
}
