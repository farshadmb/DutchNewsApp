//
//  ArticlesPageViewModel.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/24/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

/// ArticleViewModel Interface
protocol ArticlesPageViewModel: ArticlesViewModel {
    
    var count: Int { get }
    
    var currentLoadingProgress: BehaviorRelay<CGFloat> { get }
    
    func viewModel(atIndex index: Int) -> T.Item?
    
    subscript(index: Int) -> T.Item? { get }
}

// MARK: - Implemented optional methods
extension ArticlesPageViewModel {
    
    var output: Driver<[T]> {
        return .empty()
    }
    
    func refreshArticles() {
        
    }
    
    func didSelect(article: T.Item) {
        
    }
    
    func didSelect(articleAtIndex: IndexPath) {
        
    }
}
