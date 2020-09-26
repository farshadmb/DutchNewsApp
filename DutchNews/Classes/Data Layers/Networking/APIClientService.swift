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
        
        return dataRequest.rx.responseResult(queue: workQueue, responseSerializer: DecodableResponseSerializer(decoder: decoder)).map({ $1 })
            .map { value in
                return Result<T,Error> { value }
            }.catchError { (error) -> Observable<Result<T, Error>> in
            .just(.failure(error))
            }
    }
    
    private func validate(dataRequest: DataRequest, validator: NetworkValidResponse?) -> DataRequest {
        
        guard let validator = validator else {
            return dataRequest.validate()
        }
        
        return dataRequest.validate(statusCode: validator.statusCodes)
            .validate(contentType: validator.contentTypes)
        
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
                                      parameters: Parameters = [:],
                                      method: HTTPMethod = .get,
                                      headers: NetworkHeadersType = [:],
                                      validator: NetworkValidResponse? = nil,
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
            dataTask.responseString { (result) in
                
                Logger.debugLog(result.debugDescription,tag: "Networking")
            }
            return validate(dataRequest: dataTask, validator: validator)
                .responseDecodable(queue: workQueue, decoder: decoder) { (response: DataResponse<T,AFError> ) in
                    let result = response.result.flatMapError { (error) -> Result<T, Error> in
                        return .failure(error)
                    }
                    
                    completion(result)
                }
            
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
                                                   method: HTTPMethod = .get,
                                                   parameter: P,
                                                   headers: NetworkHeadersType = [:],
                                                   validator: NetworkValidResponse? = nil ,
                                                   completion: @escaping ResponseCompletion<T>) -> DataRequest? {
        do {
            
            let url = try attachBaseURL(into: endpoint)
            let dataTask = session.request(url,
                                           method: method,
                                           parameters: parameter,
                                           encoder: JSONParameterEncoder.prettyPrinted,
                                           headers: HTTPHeaders(headers),
                                           interceptor: interceptor)
            dataTask.responseString { (result) in
                Logger.debugLog(result.debugDescription,tag: "Networking")
            }
            
            return validate(dataRequest: dataTask, validator: validator)
                
                .responseDecodable(queue: workQueue, decoder: decoder) { (response: DataResponse<T,AFError> ) in
                    let result = response.result.flatMapError { (error) -> Result<T, Error> in
                        return .failure(error)
                    }
                    
                    completion(result)
            }
            
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
                                      parameters: Parameters = [:],
                                      method: HTTPMethod = .get,
                                      headers: NetworkHeadersType = [:],
                                      validator: NetworkValidResponse? = nil) -> Observable<ResponseResult<T>> {
        do {
            
            let url = try attachBaseURL(into: endpoint)
            var dataTask = session.request(url,
                                           method: method,
                                           parameters: parameters,
                                           encoding: URLEncoding.default,
                                           headers: HTTPHeaders(headers),
                                           interceptor: interceptor)
            dataTask = validate(dataRequest: dataTask, validator: validator)
            dataTask.responseString { (result) in
                Logger.debugLog(result.debugDescription,tag: "Networking")
            }
            
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
                                                   method: HTTPMethod = .get,
                                                   parameter: P,
                                                   headers: NetworkHeadersType = [:],
                                                   validator: NetworkValidResponse? = nil) -> Observable<ResponseResult<T>> {
        do {
            
            let url = try attachBaseURL(into: endpoint)
            var dataTask = session.request(url,
                                           method: method,
                                           parameters: parameter,
                                           encoder: JSONParameterEncoder.prettyPrinted,
                                           headers: HTTPHeaders(headers),
                                           interceptor: interceptor)
            dataTask = validate(dataRequest: dataTask, validator: validator)
            
            dataTask.responseString { (result) in
               Logger.debugLog(result.debugDescription,tag: "Networking")
            }
            
            return map(dataRequest: dataTask, decoder: decoder)
            
        }catch let error {
            return .just(.failure(error))
        }
    }
    
}
