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
    
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case description
        case url, urlToImage, publishedAt, content
    }
    
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

extension Article {
    
    static func htmlArticle() -> Article {
        
        return .init(title: "", author: "", description: "", source: ArticleSource(id: "", name: ""),
                     url: URL(string:"https://domain.com")!,
                     urlToImage: nil, publishedAt: Date(),
                     content: """
 <div class=\"widget\" style=\"margin: .5em 0;\">\n <a href=\"https://www.gva.be/tag/corona-gratis\">\n <img src=\"https://static.gva.be/Assets/Images_Upload/2020/03/26/fifitent.jpg\" style=\"display:block;width: 100%;\"/>\n </a>\n</div>
 """,type: .mock)
    }
    
}
