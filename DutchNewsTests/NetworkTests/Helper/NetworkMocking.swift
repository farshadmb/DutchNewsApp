//
//  NetworkMocking.swift
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

class NetworkMockBuilder {
    
    private var url: URLConvertible
    private var method: Mock.HTTPMethod = .get
    private var contentType: Mock.ContentType = .html
    private var statusCode: Int = 200
    private var data: [Mock.HTTPMethod: Data] = [:]
    private var headers: [String: String] = [:]
    
    init(URL: URLConvertible) {
        self.url = URL
    }
    
    func set(method: Mock.HTTPMethod) -> NetworkMockBuilder {
        self.method = method
        return self as NetworkMockBuilder
    }
    
    func set(contentType: Mock.ContentType) -> NetworkMockBuilder {
        self.contentType = contentType
        return self
    }
    
    func set(statusCode: Int) -> NetworkMockBuilder {
        self.statusCode = statusCode
        return self
    }
    
    func set(headers: [String: String]) -> NetworkMockBuilder {
        self.headers = headers
        return self
    }
    
    func set(data: [Mock.HTTPMethod: Data]) -> NetworkMockBuilder {
        self.data = data
        return self
    }
    
    func build() throws -> Mock {
        let mock = Mock(url: try url.asURL(),
                    contentType: contentType,
            statusCode: statusCode, data: data, additionalHeaders: headers)
        
        return mock
    }
    
}
