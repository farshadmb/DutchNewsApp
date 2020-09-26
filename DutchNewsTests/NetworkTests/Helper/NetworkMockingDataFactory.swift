//
//  NetworkMockingDataFactory.swift
//  DutchNewsTests
//
//  Created by Farshad Mousalou on 9/19/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit
import Mocker
import Alamofire
@testable import DutchNews

// swiftlint:disable all
struct NetworkMockingDataFactory {
    
    static func createSimpleJSONData() -> Data {
        let person = StubPerson(name: "John", age: 20, email: "john@gmail.com")
        let data = try! JSONEncoder().encode(person)
        return data
    }
    
    static func createSimpleArrayJSONData() -> Data {
        let persons = [StubPerson(name: "John", age: 20, email: "john@gmail.com"), StubPerson(name: "Smith", age: 40, email: nil)]
        let data = try! JSONEncoder().encode(persons)
        return data
    }
    
    
    static func createRealJSONData() -> Data {
        fatalError("")
    }
    
    static func createImageData() -> Data {
        fatalError("")
    }
    
}

struct StubPerson: Codable {
    
    let name: String
    let age: Int
    let email: String?
}
// swiftlint:enable all
