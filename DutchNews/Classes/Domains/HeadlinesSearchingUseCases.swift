//
//  HeadlinesSearchingUseCases.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift

class HeadlinesSearchingUseCases: HeadlinesUseCases {
    
    let repository: ArticleRepository
    
    init(repository: ArticleRepository) {
        self.repository = repository
    }
    
    func searchInArticle(keyword: String) -> Observable<[T]> {
        return repository.search(keyword: keyword)
    }
    
}
