//
//  ArticlesUseCase.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/24/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift

/// Abstract `ArticlesUseCase`
protocol ArticlesUseCase {
    
    typealias T = Article
    
    func fetchLocalArticles() -> Observable<[T]>
    
}

extension ArticlesUseCase {
    
    func fetchLocalArticles() -> Observable<[T]> {
        return .empty()
    }
    
}
