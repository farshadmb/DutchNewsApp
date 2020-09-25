//
//  HeadlinesArticleLocalRepository.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/24/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class HeadlinesArticleLocalRepository: ArticleRepository {
    
    typealias DataType = Article
    
    let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    func fetchArticles() -> Observable<[Article]> {
        let storage = self.storage
        return .create { obs in
            
            do {
                try storage.fetch(type: DataType.self,
                                  predicate: nil,
                                  sort: nil,
                                  completion: { (result) in
                                    obs.on(.next(result))
                                    
                })
                
            }catch {
                obs.on(.error(error))
            }
            
            return Disposables.create {
                obs.onCompleted()
            }
        }
    }
    
    func search(keyword: String) -> Observable<[Article]> {
        return fetchArticles()
            .map {
                $0.filter({ $0.title.contains(keyword) ||
                    $0.author?.contains(keyword) == true ||
                    $0.content?.contains(keyword) == true
                })
            }
    }
    
    func save(article: DataType) throws {
        try storage.save(object: article)
    }
    
    func save(articles: [DataType]) throws {
        for article in articles {
            try self.save(article: article)
        }
    }
    
}
// MARK: - Unneed Abstract methods implementation
extension HeadlinesArticleLocalRepository {
    
    func find<T>(articleByIdentifier identifier: T) -> Observable<DataType> where T: Hashable {
        return .empty()
    }
    
    func find<T>(articleByIdentifier: T) -> DataType? where T: Hashable {
        return nil
    }
    
}
