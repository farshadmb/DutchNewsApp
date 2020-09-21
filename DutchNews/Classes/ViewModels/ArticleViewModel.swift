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

//swiftlint:disable type_name

/// Abstract `ArtileViewModel`
protocol ArticleViewModel: class {
    
    typealias T = Article
    
    var state: Driver<ViewModelState> { get }
    
    var output: Driver<ArticleRepresentable> { get }
    
    var model: T { get }
    
    func buildURLContent() -> Observable<URLRequest>
    
}
//swiftlint:enable type_name

extension ArticleViewModel {
    
    func buildURLContent() -> Observable<URLRequest> {
        return output.map({
            URLRequest(url: $0.url,
                       cachePolicy: .reloadRevalidatingCacheData,
                       timeoutInterval: 30.0)
        }) .asObservable()
    }
}

extension ArticleViewModel where Self: Equatable {
    
    static func ==(lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        guard type(of: lhs) == type(of: rhs) else {
            return false
        }
        return lhs.model.publishedAt == rhs.model.publishedAt &&
            lhs.model.url == rhs.model.url &&
            lhs.model.title == rhs.model.title
    }
}

func ==(lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
    
    guard type(of: lhs) == type(of: rhs) else {
        return false
    }
    
    return lhs.model.publishedAt == rhs.model.publishedAt &&
        lhs.model.url == rhs.model.url &&
        lhs.model.title == rhs.model.title
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

func ==(lhs: ArticleRepresentable, rhs: ArticleRepresentable) -> Bool {
    
    guard type(of: lhs) == type(of: rhs) else {
        return false
    }
    return lhs.publishedAt == rhs.publishedAt && lhs.url == rhs.url && lhs.title == rhs.title
}
