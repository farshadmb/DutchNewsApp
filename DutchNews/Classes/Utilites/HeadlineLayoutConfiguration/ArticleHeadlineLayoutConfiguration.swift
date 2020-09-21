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
        case (_,0),
             (_,3):
            return sizeModeCreate(widthMode: .fullWidth(respectsHorizontalInsets: false), heightMode: .dynamic)
        case (_,1),
             (_,2):
            return sizeModeCreate(widthMode: .halfWidth, heightMode: .dynamic)
        default:
            return sizeModeCreate()
        }
    }
    
    func verticalSpacing(forElementsInSectionAtIndex section: Int) -> CGFloat {
        2.5
    }
    
    func horizontalSpacing(forElementsInSectionAtIndex section: Int) -> CGFloat {
        2.5
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Private Methods
    // MARK: -
    ////////////////////////////////////////////////////////////////

    private func sizeModeCreate(widthMode: MagazineLayoutItemWidthMode = .fullWidth(respectsHorizontalInsets: false),
                       heightMode: MagazineLayoutItemHeightMode = .dynamic) -> MagazineLayoutItemSizeMode {
        return MagazineLayoutItemSizeMode(widthMode: widthMode,heightMode: heightMode)
    }
    
}
