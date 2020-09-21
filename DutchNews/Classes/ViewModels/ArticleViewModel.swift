//
//  ArticleViewModel.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// Abstract `ArtileViewModel`
protocol ArticleViewModel: class {
    
    typealias T = Article
    
    var state: Driver<ViewModelState> { get }
    
    var output: Driver<ArticleRepresentable> { get }
    
    var model: T { get }
    
    func buildURLContent() -> Observable<URLRequest>
    
}

extension ArticleViewModel {
    
    func buildURLContent() -> Observable<URLRequest> {
        return output.map({
            URLRequest(url: $0.url,
                       cachePolicy: .reloadRevalidatingCacheData,
                       timeoutInterval: 30.0)
        }) .asObservable()
    }
}

/// `ArticleRepresentable` is representive of article output
protocol ArticleRepresentable {
    
    var title: String { get }
    var author: String? { get }
    var description: String? { get }
    
    var source: String? { get }
    
    var url: URL { get }
    
    var urlToImage: URL? { get }
    
    var publishedAt: String { get }
    
    var content: String? { get }
    
    var type: ArticleType { get }
    
}
