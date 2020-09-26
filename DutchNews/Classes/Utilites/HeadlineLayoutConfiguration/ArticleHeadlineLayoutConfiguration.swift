//
//  ArticleHeadlineLayoutConfiguration.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import MagazineLayout
import UIKit

struct ArticleHeadlineLayoutConfiguration: HeadlineLayoutConfiguration {
        
    func itemSizeMode(forItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
        switch (indexPath.section, indexPath.row) {
        case (_,0):
            return sizeModeCreate(widthMode: .fullWidth(respectsHorizontalInsets: true), heightMode: .dynamic)
        case (_,3):
            return sizeModeCreate(widthMode: .fullWidth(respectsHorizontalInsets: true), heightMode: .static(height: 80))
        case (_,1),
             (_,2):
            return sizeModeCreate(widthMode: .halfWidth, heightMode: .dynamicAndStretchToTallestItemInRow)
        default:
            return sizeModeCreate()
        }
    }
    
    func verticalSpacing(forElementsInSectionAtIndex section: Int) -> CGFloat {
        5.0
    }
    
    func horizontalSpacing(forElementsInSectionAtIndex section: Int) -> CGFloat {
        5.0
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Private Methods
    // MARK: -
    ////////////////////////////////////////////////////////////////

    private func sizeModeCreate(widthMode: MagazineLayoutItemWidthMode = .fullWidth(respectsHorizontalInsets: true),
                       heightMode: MagazineLayoutItemHeightMode = .dynamic) -> MagazineLayoutItemSizeMode {
        return MagazineLayoutItemSizeMode(widthMode: widthMode,heightMode: heightMode)
    }
    
}
