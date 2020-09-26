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
    
    var selectedIndex: BehaviorRelay<Int?> { get set }
    
    func fetchArticles()
    
    func refreshArticles()
    
    func didSelect(article: T.Item)
    
    func didSelect(articleAtIndex: IndexPath)
    
}

protocol ArticlesSearchViewModel: ArticlesViewModel {
    
    var selectedItem: BehaviorRelay<ArticleViewModel?> { get }
    
    func searchArticles(keyword: String)
    
}
