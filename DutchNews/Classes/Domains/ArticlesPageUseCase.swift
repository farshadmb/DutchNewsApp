//
//  ArticlesPageUseCase.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/25/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift

class ArticlesPageUseCase: ArticlesUseCase {
    
    let repository: ArticleRepository
    
    init(repository: ArticleRepository) {
        self.repository = repository
    }
    
    func fetchLocalArticles() -> Observable<[T]> {
        return repository.fetchArticles()
    }
}
