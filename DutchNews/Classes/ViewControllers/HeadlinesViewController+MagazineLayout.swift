//
//  HeadlinesViewController+MagazineLayout.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit
import MagazineLayout

extension HeadlinesViewController: UICollectionViewDelegateMagazineLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        visibilityModeForFooterInSectionAtIndex index: Int) -> MagazineLayoutFooterVisibilityMode {
        
        layoutConfiguration.visibleMode(forFooterAt: index)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        visibilityModeForHeaderInSectionAtIndex index: Int) -> MagazineLayoutHeaderVisibilityMode {
        layoutConfiguration.visibleMode(forHeaderAt: index)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        visibilityModeForBackgroundInSectionAtIndex index: Int) -> MagazineLayoutBackgroundVisibilityMode {
        layoutConfiguration.visibleMode(forBackground: index)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeModeForItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
        return layoutConfiguration.itemSizeMode(forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        horizontalSpacingForItemsInSectionAtIndex index: Int) -> CGFloat {
        return layoutConfiguration.horizontalSpacing(forElementsInSectionAtIndex: index)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        verticalSpacingForElementsInSectionAtIndex index: Int) -> CGFloat {
        return layoutConfiguration.verticalSpacing(forElementsInSectionAtIndex: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForSectionAtIndex index: Int) -> UIEdgeInsets {
        layoutConfiguration.insets(forSectionAtIndex: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForItemsInSectionAtIndex index: Int) -> UIEdgeInsets {
        layoutConfiguration.insets(forItemsInSectionAtIndex: index)
    }
}
