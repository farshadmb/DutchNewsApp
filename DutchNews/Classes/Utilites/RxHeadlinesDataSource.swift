//
//  RxHeadlinesDataSource.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/25/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa

/// Helper Class for fixing the issue with `MagazineLayout`
class RxHeadlinesDataSource<T>: RxCollectionViewSectionedReloadDataSource<T> where T: SectionModelType {
    
    override func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            
            let indices = (0..<element.count).compactMap({ $0 })
            
            collectionView.performBatchUpdates({
                if dataSource.sectionModels.count == 0 {
                    collectionView.insertSections(indices, animationStyle: .automatic)
                }else if dataSource.sectionModels.count == element.count {
                    collectionView.reloadSections(indices, animationStyle: .fade)
                }
                
                dataSource.setSections(element)
            }) { (finish) in
                guard finish else {
                    return
                }
                collectionView.collectionViewLayout.invalidateLayout()
            }
            
        }.on(observedEvent)
    }
    
}
