//
//  APIClientService.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/19/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import RxSwift
import RxAlamofire
import Alamofire

private let queueName = "com.ifarshad.DutchNews.networking.response"

fileprivate extension DispatchQueue {
    
    /// Default queue for handling response
    static let networkResponseQueue = DispatchQueue(label: queueName,
                                                    qos: .background,
                                                    attributes: .concurrent,
                                                    autoreleaseFrequency: .workItem)
}

/// <#Description#>
final class APIClientService: NetworkServiceInterceptable {
    
    typealias SessionManager = Session
    
    /// <#Description#>
    let baseURL: URL
    
    /// <#Description#>
    private(set) var session: SessionManager
    
    /// <#Description#>
    let workQueue: DispatchQueue
    
    private var interceptor: RequestInterceptor?
    
    let decoder: DataDecoder
    
    /// <#Description#>
    /// - Parameters:
    ///   - baseURL: <#baseURL description#>
    ///   - session: <#session description#>
    ///   - queue: <#queue description#>
    ///   - decoder: <#decoder description#>
    init(baseURL: URL,
         session: SessionManager = .default,
         queue: DispatchQueue = .networkResponseQueue,
         decoder: DataDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.session = session
        self.workQueue = queue
        self.decoder = decoder
    }
    
    func addingRequest(interceptor: RequestInterceptor) {
        let locker = NSLock()
        locker.lock()
        defer {
            locker.unlock()
        }
        
        self.interceptor = interceptor
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Private Methods
    // MARK: -
    ////////////////////////////////////////////////////////////////
    
    /// <#Description#>
    /// - Parameter endpoint: <#endpoint description#>
    private func attachBaseURL(into endpoint: URLConvertible) throws -> URLConvertible {
        
        let endPoint = try endpoint.asURL().absoluteString
        
        guard let joinedURL = URL(string: endPoint, relativeTo: baseURL) else {
            throw AFError.invalidURL(url: "\(baseURL.absoluteString)/\(endPoint)")
        }
        
        return joinedURL
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - dataRequest: <#dataRequest description#>
    ///   - decoder: <#decoder description#>
    private func map<T: Decodable> (dataRequest: DataRequest, decoder: DataDecoder) -> Observable<Result<T, Error>> {
        print(dataRequest)
        return dataRequest.rx.decodable(decoder: decoder)
            .map { value in
                return Result<T,Error> { value }
            }.catchError { (error) -> Observable<Result<T, Error>> in
            .just(.failure(error))
            }
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Abstract Implementation
    // MARK: -
    ////////////////////////////////////////////////////////////////
    
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
                                      completion: @escaping ResponseCompletion<T>) -> DataRequest? {
        do {
            
            let url = try attachBaseURL(into: endpoint)
            let headers = HTTPHeaders(headers)
            let dataTask = session.request(url,
                                           method: method,
                                           parameters: parameters,
                                           encoding: URLEncoding.default,
                                           headers: headers,
                                           interceptor: interceptor)
                .validate()
                .responseDecodable(queue: workQueue, decoder: decoder) { (response: DataResponse<T,AFError> ) in
                    let result = response.result.flatMapError { (error) -> Result<T, Error> in
                        return .failure(error)
                    }
                    
                    completion(result)
                }
            
            return dataTask
        }catch let error {
            completion(.failure(error))
            return nil
        }
    }
    
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
                                                   completion: @escaping ResponseCompletion<T>) -> DataRequest? {
        do {
            
            let url = try attachBaseURL(into: endpoint)
            let dataTask = session.request(url,
                                           method: method,
                                           parameters: parameter,
                                           encoder: JSONParameterEncoder.prettyPrinted,
                                           headers: HTTPHeaders(headers),
                                           interceptor: interceptor)
                .validate()
                .responseDecodable(queue: workQueue, decoder: decoder) { (response: DataResponse<T,AFError> ) in
                    let result = response.result.flatMapError { (error) -> Result<T, Error> in
                        return .failure(error)
                    }
                    
                    completion(result)
                }
            
            return dataTask
        }catch let error {
            completion(.failure(error))
            return nil
        }
    }
    
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
                                      headers: NetworkHeadersType) -> Observable<ResponseResult<T>> {
        do {
            
            let url = try attachBaseURL(into: endpoint)
            let dataTask = session.request(url,
                                           method: method,
                                           parameters: parameters,
                                           encoding: URLEncoding.default,
                                           headers: HTTPHeaders(headers),
                                           interceptor: interceptor)
                .validate()
            
            return map(dataRequest: dataTask, decoder: decoder)
            
        }catch let error {
            return .just(.failure(error))
        }
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - endpoint: <#endpoint description#>
    ///   - method: <#method description#>
    ///   - parameter: <#parameter description#>
    ///   - headers: <#headers description#>
    func executeRequest<T: Decodable,P: Encodable>(endpoint: EndPoint,
                                                   method: HTTPMethod,
                                                   parameter: P, headers: NetworkHeadersType) -> Observable<ResponseResult<T>> {
        do {
            
            let url = try attachBaseURL(into: endpoint)
            let dataTask = session.request(url,
                                           method: method,
                                           parameters: parameter,
                                           encoder: JSONParameterEncoder.prettyPrinted,
                                           headers: HTTPHeaders(headers),
                                           interceptor: interceptor)
                .validate()
            return map(dataRequest: dataTask, decoder: decoder)
            
        }catch let error {
            return .just(.failure(error))
        }
    }
    
}
