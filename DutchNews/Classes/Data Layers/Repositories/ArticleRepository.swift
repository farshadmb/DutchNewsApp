//
//  Repository.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift

/// `ArticleRepository` Abstract.
protocol ArticleRepository: class {
    
    typealias DataType = Article
    
    /// <#Description#>
    func fetchArticles() -> Observable<[DataType]>
    
    /// <#Description#>
    /// - Parameter keyword: <#keyword description#>
    func search(keyword: String) -> Observable<[DataType]>
    
    /// <#Description#>
    /// - Parameter articleByIdentifier: <#articleByIdentifier description#>
    func find<T: Hashable>(articleByIdentifier: T) -> Observable<DataType>
    
    /// <#Description#>
    /// - Parameter articleByIdentifier: <#articleByIdentifier description#>
    func find<T: Hashable>(articleByIdentifier: T) -> DataType?
    
    /// <#Description#>
    /// - Parameter article: <#article description#>
    func save(article: DataType) throws
    
    /// <#Description#>
    /// - Parameter articles: <#articles description#>
    func save(articles: [DataType]) throws
    
}
