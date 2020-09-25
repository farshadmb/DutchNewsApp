//
//  HeadlinesFetchingUseCase.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift

class HeadlinesFetchingUseCase: HeadlinesUseCases {
    
    let repository: ArticleRepository
    let local: ArticleRepository?
    
    init(repository: ArticleRepository) {
        self.repository = repository
        self.local = nil
    }
    
    init(repository: ArticleRepository, localRespository: ArticleRepository) {
        self.repository = repository
        self.local = localRespository
    }
    
    func fetchArticles() -> Observable<[T]> {
        return loadLocalThenFetchFromAPI()
    }
    
    private func loadLocalThenFetchFromAPI() -> Observable<[T]> {
        
        let remoteSource = repository.fetchArticles()
        guard let localSource = local?.fetchArticles() else {
            return remoteSource
        }
        
        let source = Observable.merge(remoteSource, localSource)
        
        return source
            .debug("#\(#file.replacingOccurrences(of: ".swift", with: "")).\(#function)")
            .do(afterNext: {[weak local] in
                try? local?.save(articles: $0)
            })
    }
    
}
