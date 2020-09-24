//
//  CodableDataManagerTests.swift
//  DutchNewsTests
//
//  Created by Farshad Mousalou on 9/24/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import XCTest
import Foundation

@testable import DutchNews

class CodableDataManagerTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSaveObject() {
        do {
            
            let storage: Storage = CodableDataManager(fileProvider: .custom(url: try! URL.documentDirectoryURL()))
            
            try storage.save(object: Article.htmlArticle())
            try storage.save(object: Article.htmlArticle())
            
        }catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testFetchAllElements() {
        
        do {
            let expe = self.expectation(description: "testEEE")
            expe.expectedFulfillmentCount = 1
            
            let storage: Storage = CodableDataManager(fileProvider: .custom(url: try! URL.documentDirectoryURL()))
            
            try storage.save(object: Article.htmlArticle())
            try storage.save(object: Article.htmlArticle())
            try storage.save(object: Article.htmlArticle())
            try storage.save(object: Article.htmlArticle())
            
            try storage.fetch(type: Article.self, predicate: nil, sort: nil) { (result) in
                print(result)
                expe.fulfill()
            }
            
            self.waitForExpectations(timeout: 30.0) { (error) in
                if let error = error {
                    XCTFail(error.localizedDescription)
                }
            }
        }catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testFetchElementsWithPrediction() {
        
        do {
            let expe = self.expectation(description: "testEEE")
            expe.expectedFulfillmentCount = 2
            
            let storage: Storage = CodableDataManager(fileProvider: .custom(url: try! URL.documentDirectoryURL()))
            
             let people = [StubPerson(name: "John", age: 21, email: "m@mail.com"),
            StubPerson(name: "Sam", age: 35, email: "sam@gmail.com"),
            StubPerson(name: "Goorge", age: 40, email: "goorge@gmail.com")]
            
            for person in people {
                try? storage.save(object: person)
            }
            
            let commitPredicate = NSPredicate { (obj, _) -> Bool in
                return ((obj as? StubPerson)?.name ?? "") == "John"
            }
            
            try storage.fetch(type: StubPerson.self, predicate: commitPredicate, sort: nil) { (result) in
                XCTAssertTrue(result.count > 0, "Not Found John")
                expe.fulfill()
            }
            
            let predict2 = NSPredicate { (obj, _) -> Bool in
                return ((obj as? StubPerson)?.email ?? "").contains(".com")
            }
            
            try storage.fetch(type: StubPerson.self, predicate: predict2, sort: nil) { (result) in
                XCTAssertTrue(result.count > 0, "no names found in list which contains 'o'")
                expe.fulfill()
            }
            
            self.waitForExpectations(timeout: 30.0) { (error) in
                if let error = error {
                    XCTFail(error.localizedDescription)
                }
            }
        }catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension StubPerson: Storable {
    
    func primaryKeyValue() -> String {
        return self.name
    }
    
}

extension StubPerson: Equatable {
   
    static func ==(lhs: StubPerson, rhs: StubPerson) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age && lhs.email == rhs.email
    }
    
}
