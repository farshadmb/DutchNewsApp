//
//  HeadlinesArticleRemoteRepository.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class HeadlinesArticleRemoteRepository: ArticleRepository {
     
    typealias DataType = Article
    
    let networkService: NetworkServiceInterceptable
    let validator: NetworkValidResponse?
    
    init(networkService: NetworkServiceInterceptable,
         authentictor: RequestInterceptor,
         validator: NetworkValidResponse? = nil) {
        
        self.networkService = networkService
        self.networkService.addingRequest(interceptor: authentictor)
        self.validator = validator
    }
    
    private typealias ResponseResult = Result<APIServerResponse<[DataType]>,Error>
    
    func fetchArticles() -> Observable<[Article]> {
        
        return networkService.executeRequest(endpoint: "top-headlines",
                                             parameters: ["country": "nl"],
                                             method: .get, headers: [:],
                                             validator: validator)
            .map(map(response:))
    }
    
    func search(keyword: String) -> Observable<[Article]> {
        networkService.executeRequest(endpoint: "top-headlines",
                                      parameters: ["q": keyword,"country": "nl"],
                                      method: .get, headers: [:],
                                      validator: validator)
            .map(map(response:))
    }
    
    func get<K>(identiferKey: K) -> [DataType] where K: Hashable {
        fatalError()
    }
    
    private func map(response: ResponseResult) throws -> [Article] {
        let result = try response.get()
        return result.data ?? []
    }
    
}

// MARK: - Unneed method implementation
extension HeadlinesArticleRemoteRepository {
    
    func find<T>(articleByIdentifier: T) -> Observable<DataType> where T: Hashable {
        return .empty()
    }
    
    func find<T>(articleByIdentifier: T) -> DataType? where T: Hashable {
        return nil
    }
    
    func save(article: DataType) throws {
        
    }
    
    func save(articles: [DataType]) throws {
        
    }
    
}
