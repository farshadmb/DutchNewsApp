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
    
//    override func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
//        Binder(self) { dataSource, element in
//        
//            dataSource.setSections(element)
//            collectionView.reloadData()
//            collectionView.collectionViewLayout.invalidateLayout()
//            
//        }.on(observedEvent)
//    }
    
}
