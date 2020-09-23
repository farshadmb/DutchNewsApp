//
//  HeadlinesUseCases.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift

/// Abstract `HeadlinesUseCases`
protocol HeadlinesUseCases {
    
    typealias T = Article
    
    func fetchArticles() -> Observable<[T]>
    func searchInArticle(keyword: String) -> Observable<[T]>
}

extension HeadlinesUseCases {
    
    func fetchArticles() -> Observable<[T]> {
        return .empty()
    }
    
    func searchInArticle(keyword: String) -> Observable<[T]> {
        return .empty()
    }
}
