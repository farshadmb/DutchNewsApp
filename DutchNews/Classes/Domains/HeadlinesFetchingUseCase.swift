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
    
    init(repository: ArticleRepository) {
        self.repository = repository
    }
    
    func fetchArticles() -> Observable<[T]> {
        return repository.fetchArticles()
    }
        
}
