//
//  Repository.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift

protocol ArticleRepository {
    
    associatedtype T: Codable
    
    /// <#Description#>
    func fetchArticles() -> Observable<[T]>
    
    /// <#Description#>
    /// - Parameter keyword: <#keyword description#>
    func search(keyword: String) -> Observable<[T]>
    
}
