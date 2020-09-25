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
    
    typealias SectionType = ArticlesViewModel.T
    
    func buildDataSource() -> RxHeadlinesDataSource<SectionType> {
        
        return RxHeadlinesDataSource(configureCell: {[weak self] (dataSource, collectionView, indexPath, _) -> UICollectionViewCell in
            
            guard let `self` = self else {
                return HeadlineBaseCollectionViewCell()
            }
            
            let item = dataSource[indexPath]
            
            let reuseId = self.reuseItentifier(forCellAt: indexPath, item: item.model).id
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
            
            self.fill(cell: cell, withArticle: item)
            
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
    
    private func fill(cell: UICollectionViewCell, withArticle article: ArticleViewModel) {
        
        switch (cell) {
        case (let cell as ArticleWebContainerCollectionViewCell) where article.model.type == .mock :
            
            if cell.contentLabel.text == nil,
                let content = article.model.content {
                
                cell.webView.loadHTMLString(content, baseURL: nil)
                cell.contentLabel.text = content
                
            }
        case (let cell as HeadlineBaseCollectionViewCell):
            article.output
                .debug()
                .drive(onNext: {[weak cell] viewModel in
                    cell?.config(viewModel: viewModel)
                }).disposed(by: cell.disposeBag)
        default:
            break
        }
    }
    
}
