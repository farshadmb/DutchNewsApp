//
//  HeadlinesViewController+DataSource.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxDataSources

extension HeadlinesViewController {
    
    typealias SectionType = SectionModel<Int,Article>
    
    func buildDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionType> {
        
        return RxCollectionViewSectionedReloadDataSource(configureCell: {[weak self] (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            
            guard let `self` = self else {
                return HeadlineBaseCollectionViewCell()
            }
            
            let item2 = dataSource[indexPath]
            
            let reuseId = self.reuseItentifier(forCellAt: indexPath, item: item2).id
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
            
            self.fill(cell: cell, withArticle: item2)
            
            cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
            cell.contentView.layer.borderWidth = 0.4
            cell.contentView.layer.cornerRadius = 8.0
            
            return cell
        })
    }
    
    /// <#Description#>
    /// - Parameter index: <#index description#>
    private func reuseItentifier(forCellAt index: IndexPath, item: Article) -> HeadlinesCellIdentifier {
        
        switch (index.section, index.item) {
        case (_,0):
            return .main
        case (_,3) where item.type == .mock :
            return .web
        case (_,1),
             (_,2):
            return .halfWidth
        default:
            return .row
        }
    }
    
    private func fill(cell: UICollectionViewCell, withArticle article: Article) {
        
        switch (cell) {
        case (let cell as MainArticleCollectionViewCell):
            cell.titleLabel.text = article.title
        case (let cell as HalfWidthArticleCollectionViewCell):
            cell.titleLabel.text = article.title
            cell.sourceLabel.text = article.source.name
            
        case (let cell as ArticleWebContainerCollectionViewCell) where article.type == .mock :
            
            if cell.contentLabel.text == nil,
                let content = article.content {
            
                cell.webView.loadHTMLString(content, baseURL: nil)
                cell.contentLabel.text = content
                
                //FIXME: determind a observation for callback purpose when loading was finished.
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {[weak self] in
                    self?.collectionView.reloadData()
                    self?.collectionLayout?.invalidateLayout()
                }
            }
            
        case (let cell as ArticleRowCollectionViewCell):
            
            print(article)
            cell.titleLabel.text = article.title
            cell.descriptionLabel.text = article.description
            cell.sourceLabel.text = article.source.name
            cell.dateLabel.text = article.publishedAt.description(with: Locale.current)
            
        default:
            break
        }
    }
    
    func buildMockData() -> SectionType {
        
        let bundle = Bundle(for: type(of: self))
        guard let data = try? Data(contentsOf: bundle.url(forResource: "HeadlineSuccessResponse", withExtension: "json")!) else {
            return SectionType(model: 0, items: [])
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.dataDecodingStrategy = .deferredToData
        
        guard let response = try? decoder.decode(APIServerResponse<[Article]>.self, from: data),
            var items = response.data else {
            return SectionType(model: 0, items: [])
        }
        
        if items.count > 3 {
            items.insert(Article.htmlArticle(), at: 3)
        }
        
        return SectionType(model: 0, items: items)
        
    }
    
}
