//
//  APIServerResponse.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

struct APIServerResponse <T> where T: Decodable {
    
    var status: APIServerResponseStatus = .success
    var message: String?
    var articles: T?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case code = "code"
        case message = "message"
        case data = "articles"
    }
    
    init(status: APIServerResponseStatus) {
        self.status = status
    }
    
}

extension APIServerResponse: Decodable {
    
    public init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try values.decode(APIServerResponseStatus.self, forKey: .status)
        
        do {
            self.message = try values.decodeIfPresent(String.self, forKey: .message)
        }catch {
            self.message = nil
        }
        
        guard status == .success else {
            
            if let errorType = try? values.decodeIfPresent(String.self, forKey: .code) {
                
                if let message = try? values.decodeIfPresent(String.self, forKey: .message) {
                    throw APIServerResponseError.message("\(errorType)", message)
                }else {
                    throw APIServerResponseError.code("Code: \(errorType)")
                }
                
            }else {
                throw APIServerResponseError.unknown
            }
            
            self.articles = nil
            return
        }
        
        do {
            self.articles = try values.decodeIfPresent(T.self, forKey: .data)
        }catch {
            self.articles = nil
            throw APIServerResponseError.code(error.localizedDescription)
        }
        
    }
    
}

extension APIServerResponse: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return "[Server-Response] status = \(status) message= \(message ?? "no message") error = empty data = \(articles)"
    }
}
