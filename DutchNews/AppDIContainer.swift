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
        return HeadlinesFetchingUseCase(repository: headlineArticleRepository)
                                        
    }
    
    static var articlesPageUseCase: ArticlesUseCase {
        return ArticlesPageUseCase(repository: headlineArticleRepository)
    }
    
    static var headlineSearchUseCase: HeadlinesUseCases {
        return HeadlinesSearchingUseCases(repository: headlineArticleRepository)
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: ViewModels DI Container
    // MARK: -
    ////////////////////////////////////////////////////////////////

    static var headlinesViewModel: ArticlesViewModel {
        return HeadlinesViewModel(useCase: headlineFetchingUseCase)
    }
    
    static var articlePagesViewModel: ArticlesPageViewModel {
        return ArticleDetailsPageViewModel(useCase: articlesPageUseCase)
    }
    
    static var headlineSearchViewModel: ArticlesSearchViewModel {
        return HeadlineSearchViewModel(useCase: headlineSearchUseCase)
    }
    
    static let viewModelViewControllerFactory: ViewControllerFactory = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: AppDelegate.self))
        return ViewModelViewControllerFactory(storyboard: storyboard)
    }()
    
}
