//
//  ModelTests.swift
//  DutchNewsTests
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import XCTest

@testable import DutchNews

class ModelTests: XCTestCase {
    
    var decoder: JSONDecoder!
    
    override func setUp() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        decoder = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDecodingArticles() {
        
        let data = ModelsDataFactory.createMockArticlesData()
        
        do {
            let objects = try decoder.decode([Article].self, from: data)
            XCTAssert(objects.count >= 0 , "data was not able to decode.")
            print("Decoded Objc ", objects)
        }catch let error {
            XCTFail("Error Occurred info: \(error) \(error.localizedDescription)")
        }
    }
    
    func testDecodingArticleSource() {
        
        let data = ModelsDataFactory.createMockSource()
        
        do {
            let object = try decoder.decode(ArticleSource.self, from: data)
            XCTAssertNotNil(object, "Data was not able to decode.")
            print("Decoded Objc ", object)
        }catch let error {
            XCTFail("Error Occurred info: \(error) \(error.localizedDescription)")
        }
    }
    
    func testHandleDecodingErrorWhenDataCorrupted() {
        var corruptedData = ModelsDataFactory.createCorruptedMockArticlesData()
        corruptedData = "G ".data(using: .utf8)! + corruptedData
        
        do {
            let object = try decoder.decode([Article].self, from: corruptedData)
            XCTAssertNil(object, "The Data was decoded successfully. detail: \(object)")
            
        }catch let error {
            print("expected result -> ",error,error.localizedDescription)
        }
    }
    
    func testHandleDecodingErrorWhenArticlesCorrupted() {
        
        let corruptedData = ModelsDataFactory.createCorruptedMockArticlesData()
        
        do {
            let object = try decoder.decode([Article].self, from: corruptedData)
            XCTAssertNil(object, "Responsed was decoded successfully. detail: \(object)")
            
        }catch let error {
            print("expected result -> ",error,error.localizedDescription)
        }
    }
    
    func testHandleDecodingErrorWhenArticleSourceCorrupted() {
        
        let data = ModelsDataFactory.createCorruptedMockSource()
        do {
            let object = try decoder.decode(ArticleSource.self, from: data)
            XCTAssertNil(object, "Responsed was decoded successfully")
            print("Decoded Objc ", object)
        }catch let error {
            print("expected result -> ",error,error.localizedDescription)
        
        }
    }
}
