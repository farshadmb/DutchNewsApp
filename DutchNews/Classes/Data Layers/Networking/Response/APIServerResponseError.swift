//
//  APIServerResponseError.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

enum APIServerResponseError: Error {
    case code(String)
    case message(String, String)
    case unknown
}

extension APIServerResponseError: LocalizedError {
    
    var errorDescription: String? {
        return self.errorDes
    }
    
    fileprivate var errorDes: String {
        return self.message
    }
}

extension APIServerResponseError {
    
    var type: String {
        switch self {
        case .code(let type),
             .message(let type, _):
            return type
        case .unknown :
            return "UNKNOWN_ERROR"
        }
    }
    
    var message: String {
        
        switch self {
        case .code(let value):
            return value
        case .message(_ , let msg):
            return msg
        case .unknown :
            return "Unknown Error Occured. Please Contact Support"
        }
    }
    
}
