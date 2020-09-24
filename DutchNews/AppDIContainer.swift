//
//  AppDIContainer.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct AppDIContainer {
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Data Layers DI Container
    // MARK: -
    ////////////////////////////////////////////////////////////////
    
    static let authenticator: RequestInterceptor = {
        return APIAuthenticator(token: AppConfig.APIKey)
    }()
    
    static let authorizedNetworkService: NetworkServiceInterceptable = {
        let session = Session()
        session.sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let apiClient = APIClientService(baseURL: AppConfig.BaseURL, session: session, decoder: decoder)
        apiClient.addingRequest(interceptor: authenticator)
        return apiClient
    }()
    
    static let networkService: NetworkServiceInterceptable = {
        let session = Session()
        session.sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return APIClientService(baseURL: AppConfig.BaseURL, session: session, decoder: decoder)
    }()
    
    static let decoder: DataDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    static let storage: Storage = {
        return CodableDataManager.default
    }()
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Repository DI Container
    // MARK: -
    ////////////////////////////////////////////////////////////////
    
    static var headlineArticleRepository: ArticleRepository {
        return HeadlinesArticleRemoteRepository(networkService: authorizedNetworkService,
                                                authentictor: authenticator,
                                                validator: DefaultAPIValidResponse())
    }
    
    static var headlineLocalArticleRepository: ArticleRepository {
        return HeadlinesArticleLocalRepository(storage: storage)
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Use Cases DI Container
    // MARK: -
    ////////////////////////////////////////////////////////////////

    static var headlineFetchingUseCase: HeadlinesUseCases {
        return HeadlinesFetchingUseCase(repository: headlineArticleRepository,
                                        localRespository: headlineLocalArticleRepository)
    }
    
    static var articlesPageUseCase: ArticlesUseCase {
        return ArticlesPageUseCase(repository: headlineLocalArticleRepository)
    }
    
}
