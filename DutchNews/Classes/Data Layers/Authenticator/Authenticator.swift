//
//  Authenticator.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/19/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import Alamofire

struct APIAuthenticator: RequestInterceptor {
    
    let token: String
    
    init(token: String) {
        self.token = token
    }
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        request.headers.add(HTTPHeader.authorization(bearerToken: self.token))
        completion(Result { request })
    }
    
}
