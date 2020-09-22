//
//  HeadlineCellViewModel.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HeadlineCellViewModel: ArticleViewModel {
    
    var state: Driver<ViewModelState> {
        return .empty()
    }
    
    var output: Driver<ArticleRepresentable> {
        return _output.asDriver()
    }
    
    private var _output: BehaviorRelay<ArticleRepresentable>
    
    var model: T {
        didSet {
            guard model != oldValue else {
                return
            }
            _output.accept(Self.convert(model: model))
        }
    }
    
    init(model: T) {
        self.model = model
        _output = BehaviorRelay(value: Self.convert(model: model))
    }
    
    private static func convert(model: T) -> ArticleRepresentable {
        
        let dateFormatter = DateFormatter.currentZoneFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return HeadlineCellOutput(title: model.title,
                                  author: model.author,
                                  description: model.title,
                                  source: model.source.name,
                                  url: model.url,
                                  urlToImage: model.urlToImage,
                                  publishedAt: dateFormatter.string(from: model.publishedAt),
                                  content: model.content, type: model.type)
    }
    
}

extension HeadlineCellViewModel: Hashable {
    
    static func == (lhs: HeadlineCellViewModel, rhs: HeadlineCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(model.title)
        hasher.combine(model.publishedAt)
        hasher.combine(model.url)
    }
}

private extension HeadlineCellViewModel {
    
    struct HeadlineCellOutput: ArticleRepresentable {
        
        var title: String
        var author: String?
        var description: String?
        var source: String?
        var url: URL
        var urlToImage: URL?
        var publishedAt: String
        var content: String?
        
        var type: ArticleType
        
    }
    
}
