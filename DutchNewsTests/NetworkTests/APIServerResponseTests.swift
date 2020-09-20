//
//  APIServerResponseTests.swift
//  DutchNewsTests
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import XCTest
import Foundation

@testable import DutchNews

class APIServerResponseTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSuccessAPIResponse() {
        let data = """
            {
                "status": "ok",
                "totalResults": 34,
                "articles": []
            }
        """.data(using: .utf8)!
        do {
            let response = try JSONDecoder().decode(APIServerResponse<[String]>.self, from: data)
            XCTAssert(response.status == .success , "APIServerResponse data was not able to decode.")
            XCTAssertNotNil(response.data, "APIServerResponse data was not able to decode.")
            
            print("Decoded Objc ", response)
        }catch let error {
            XCTFail("Error Occurred info: \(error) \(error.localizedDescription)")
        }
    }
    
    func testFailureAPIResponse() {
        let data = """
            {
                "status": "error",
                "code": "apiKeyInvalid",
                "message": "Your API key is invalid or incorrect. Check your key, or go to https://newsapi.org to create a free API key."
            }
            """.data(using: .utf8)!
        
        do {
            let response = try JSONDecoder().decode(APIServerResponse<[String]>.self, from: data)
            XCTAssertNil(response, "Responsed was decoded successfully. detail: \(response)")
        }catch let error {
            print("expected result -> ",error,error.localizedDescription)
        }
        
    }
    
    func testSuccessDecoding() {
        let data = """
                   {
                       "status": "ok",
                       "totalResults": 34,
                       "articles": []
                   }
               """.data(using: .utf8)!
        do {
            let response = try JSONDecoder().decode(APIServerResponse<[String]>.self, from: data)
            XCTAssert(response.status == .success , "APIServerResponse data was not able to decode.")
            XCTAssertNotNil(response, "APIServerResponse data was not able to decode.")
            
            print("Decoded Objc ", response)
        }catch let error {
            XCTFail("Error Occurred info: \(error) \(error.localizedDescription)")
        }
    }
    
    func testFailureDecoding() {
        let data = """
                   {
                       "status": "fail",
                       "message": "Your API key is invalid or incorrect. Check your key, or go to https://newsapi.org to create a free API key."
                   }
                   """.data(using: .utf8)!
        
        do {
            let response = try JSONDecoder().decode(APIServerResponse<[String]>.self, from: data)
            XCTAssertNil(response, "Responsed was decoded successfully. detail: \(response)")
        }catch let error {
            print("expected result -> ",error,error.localizedDescription)
        }
    }
    
}
