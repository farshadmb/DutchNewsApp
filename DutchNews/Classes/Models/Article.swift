//
//  Article.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

struct Article: Codable {
    
    let title: String
    let author: String?
    let description: String?
    
    let source: ArticleSource
    
    let url: URL

    let urlToImage: URL?

    let publishedAt: Date

    let content: String?
    
    var type: ArticleType = .news
    
}

enum ArticleType: Int, Codable {
    case news
    case mock
}

extension Article: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(source)
        hasher.combine(url)
        hasher.combine(type)
    }
}
