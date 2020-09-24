//
//  Article.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

struct Article: Storable, Codable {
   
    let title: String
    let author: String?
    let description: String?
    
    let source: ArticleSource
    
    let url: URL
    
    var urlToImage: URL? {
        guard let urlStr = imageUrl, let url = URL(string: urlStr) else {
            return nil
        }
        return url
    }
    
    private let imageUrl: String?
    
    let publishedAt: Date
    
    let content: String?
    
    var type: ArticleType = .news
    
    enum CodingKeys: String, CodingKey {
        case source, author, title
        case description
        case url
        case imageUrl = "urlToImage"
        case publishedAt, content
    }
    
    init(title: String, author: String? = nil, description: String? = nil,
         source: ArticleSource,
         url: URL, imageUrl: URL? = nil , publishedAt: Date = .now,
         content: String? = nil, type: ArticleType = .news) {
        
        self.title = title
        self.author = author
        self.description = description
        self.url = url
        self.imageUrl = imageUrl?.absoluteString
        self.publishedAt = publishedAt
        self.source = source
        self.content = content
        self.type = type
        
    }
    
    func primaryKeyValue() -> String {
        return url.absoluteString + "\(publishedAt.timeIntervalSince1970)"
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
        hasher.combine(publishedAt)
        
    }
}

extension Article {
    
    static func htmlArticle() -> Article {
        
        return .init(title: "", author: "", description: "", source: ArticleSource(id: "", name: ""),
                     url: URL(string: "https://domain.com")!,
                     imageUrl: nil, publishedAt: Date(),
                     content: """
 <div class=\"widget\" style=\"margin: .5em 0;\">\n <a href=\"https://www.gva.be/tag/corona-gratis\">\n <img src=\"https://static.gva.be/Assets/Images_Upload/2020/03/26/fifitent.jpg\" style=\"display:block;width: 100%;\"/>\n </a>\n</div>
 """,type: .mock)
    }
    
}
