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
    typealias NetworkHeadersType = [String: String]
    
    /// <#Description#>
    typealias NetworkParametersType = Parameters
    
    /// <#Description#>
    typealias ResponseResult<T> = Swift.Result<T,Error>
    
    typealias ResponseCompletion<T> = (ResponseResult<T>) -> Void
    
    typealias Parameters = [String: Any]
    
    typealias EndPoint = URLConvertible
    
    /// <#Description#>
    /// - Parameters:
    ///   - endpoint: <#endpoint description#>
    ///   - parameters: <#parameters description#>
    ///   - method: <#method description#>
    ///   - headers: <#headers description#>
    ///   - completion: <#completion description#>
    func executeRequest<T: Decodable>(endpoint: EndPoint,
                                      parameters: Parameters,
                                      method: HTTPMethod,
                                      headers: NetworkHeadersType,
                                      validator: NetworkValidResponse?,
                                      completion: @escaping ResponseCompletion<T>) -> DataRequest?
    
    /// <#Description#>
    /// - Parameters:
    ///   - endpoint: <#endpoint description#>
    ///   - method: <#method description#>
    ///   - parameter: <#parameter description#>
    ///   - headers: <#headers description#>
    ///   - completion: <#completion description#>
    func executeRequest<T: Decodable,P: Encodable>(endpoint: EndPoint,
                                                   method: HTTPMethod,
                                                   parameter: P, headers: NetworkHeadersType,
                                                   validator: NetworkValidResponse?,
                                                   completion: @escaping ResponseCompletion<T>) -> DataRequest?
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: RxSwift Methods
    // MARK: -
    ////////////////////////////////////////////////////////////////

    /// <#Description#>
    /// - Parameters:
    ///   - endpoint: <#endpoint description#>
    ///   - parameters: <#parameters description#>
    ///   - method: <#method description#>
    ///   - headers: <#headers description#>
    func executeRequest<T: Decodable>(endpoint: EndPoint,
                                      parameters: Parameters,
                                      method: HTTPMethod,
                                      headers: NetworkHeadersType,
                                      validator: NetworkValidResponse?) -> Observable<ResponseResult<T>>
    
    /// <#Description#>
    /// - Parameters:
    ///   - endpoint: <#endpoint description#>
    ///   - method: <#method description#>
    ///   - parameter: <#parameter description#>
    ///   - headers: <#headers description#>
    func executeRequest<T: Decodable,P: Encodable>(endpoint: EndPoint,
                                                   method: HTTPMethod,
                                                   parameter: P, headers: NetworkHeadersType,
                                                   validator: NetworkValidResponse?) -> Observable<ResponseResult<T>>
    
}

/// <#Description#>
protocol NetworkServiceInterceptable: NetworkService {
    
    /// <#Description#>
    /// - Parameter interceptor: <#interceptor description#>
    func addingRequest(interceptor: RequestInterceptor)
}

extension NetworkService {

    func executeRequest<T: Decodable>(endpoint: EndPoint,
                                      parameters: Parameters,
                                      method: HTTPMethod,
                                      headers: NetworkHeadersType,
                                      validator: NetworkValidResponse? = nil,
                                      completion: @escaping ResponseCompletion<T>) -> DataRequest? {
        return nil
    }
    
    func executeRequest<T: Decodable,P: Encodable>(endpoint: EndPoint,
                                                   method: HTTPMethod,
                                                   parameter: P, headers: NetworkHeadersType,
                                                   validator: NetworkValidResponse? = nil,
                                                   completion: @escaping ResponseCompletion<T> ) -> DataRequest? {
        return nil
    }
    
    func executeRequest<T: Decodable>(endpoint: EndPoint,
                                      parameters: Parameters,
                                      method: HTTPMethod,
                                      headers: NetworkHeadersType,
                                      validator: NetworkValidResponse? = nil) -> Observable<ResponseResult<T>> {
        return .empty()
    }

    func executeRequest<T: Decodable,P: Encodable>(endpoint: EndPoint,
                                                   method: HTTPMethod,
                                                   parameter: P, headers: NetworkHeadersType,
                                                   validator: NetworkValidResponse? = nil) -> Observable<ResponseResult<T>> {
        return .empty()
    }
}
