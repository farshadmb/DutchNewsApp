//
//  ArticlesViewModel.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

/// ArticleViewModel Interface
protocol ArticlesViewModel: class {
    
    typealias T = SectionModel<String,ArticleViewModel>
    
    var state: Driver<ViewModelState> { get }
    
    var output: Driver<[T]> { get }
    
    func fetchArticles()
    
    func refreshArticles()
    
    func article(atIndex: IndexPath) -> T.Item?
    
    func didSelect(article: T.Item)
    
    func didSelect(articleAtIndex: IndexPath)
    
}

protocol ArticlesSearchViewModel: ArticlesViewModel {
    
    func searchArticles(keyword: String) -> Observable<[T]>
}
