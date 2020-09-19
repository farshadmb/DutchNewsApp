//
//  NetworkService.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/19/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

/// `NetworkService` Abstract
protocol NetworkService {
    
    /// <#Description#>
    typealias NetworkHeadersType = [String : String]
    
    /// <#Description#>
    typealias NetworkParametersType = Parameters
    
    /// <#Description#>
    typealias ResponseResult<T> = Swift.Result<T,Error>
    
    typealias Parameters = [String: Any]
    
    typealias EndPoint = URLConvertible
   
    
    /// <#Description#>
    /// - Parameters:
    ///   - endpoint: <#endpoint description#>
    ///   - parameters: <#parameters description#>
    ///   - method: <#method description#>
    ///   - headers: <#headers description#>
    func executeRequest<T: Decodable>(endpoint: EndPoint,
                                      parameters: Parameters,
                                      method: HTTPMethod,
                                      headers: NetworkHeadersType) -> Observable<ResponseResult<T>>
    
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - endpoint: <#endpoint description#>
    ///   - parameter: <#parameter description#>
    ///   - headers: <#headers description#>
    func executeRequest<T: Decodable,P: Encodable>(endpoint: EndPoint,
                                                    parameter: P, headers: NetworkHeadersType) -> Observable<ResponseResult<T>>
    
}

protocol NetworkServiceInterceptable: NetworkService {
    
    /// <#Description#>
    /// - Parameter interceptor: <#interceptor description#>
    func addingRequest(interceptor: RequestInterceptor)
}

extension NetworkService {
    
   
    func executeRequest<T: Decodable>(endpoint: EndPoint,
                                       parameters: Parameters,
                                       method: HTTPMethod, headers: NetworkHeadersType) -> Observable<ResponseResult<T>> {
        return .empty()
    }
    
    func executeRequest<T: Decodable,P: Encodable>(endpoint:EndPoint,
                                                    parameter: P,
                                                    headers: NetworkHeadersType) -> Observable<ResponseResult<T>> {
        return .empty()
    }
}
