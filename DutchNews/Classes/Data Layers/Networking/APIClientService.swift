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
         decoder: @autoclosure () -> DataDecoder) {
        self.baseURL = baseURL
        self.session = session
        self.workQueue = queue
        self.decoder = decoder()
        
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
    //MARK:-
    //MARK:Private Methods
    //MARK:-
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
    
}
