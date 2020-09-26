//
//  HeadlineLayoutConfiguration.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit
import MagazineLayout

/// `HeadlineLayoutConfiguration` Abstract
protocol HeadlineLayoutConfiguration {
    
    var defaultHeight: CGFloat { get }
    
    func itemSizeMode(forItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode
    func visibleMode(forFooterAt section: Int) -> MagazineLayoutFooterVisibilityMode
    func visibleMode(forHeaderAt section: Int) -> MagazineLayoutHeaderVisibilityMode
    func visibleMode(forBackground section: Int) -> MagazineLayoutBackgroundVisibilityMode
    
    func insets(forSectionAtIndex section: Int) -> UIEdgeInsets
    func insets(forItemsInSectionAtIndex section: Int) -> UIEdgeInsets
    
    func verticalSpacing(forElementsInSectionAtIndex section: Int) -> CGFloat
    func horizontalSpacing(forElementsInSectionAtIndex section: Int) -> CGFloat
    
}

extension HeadlineLayoutConfiguration {
    
    var defaultHeight: CGFloat { 44 }
    
    func itemSizeMode(forItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
        return MagazineLayoutItemSizeMode(widthMode: .fullWidth(respectsHorizontalInsets: true),
                                          heightMode: MagazineLayoutItemHeightMode.static(height: defaultHeight))
    }
    
    func visibleMode(forFooterAt section: Int) -> MagazineLayoutFooterVisibilityMode {
        .hidden
    }
    
    func visibleMode(forHeaderAt section: Int) -> MagazineLayoutHeaderVisibilityMode {
        .hidden
    }
    
    func visibleMode(forBackground section: Int) -> MagazineLayoutBackgroundVisibilityMode {
        .hidden
    }
    
    func insets(forSectionAtIndex section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func insets(forItemsInSectionAtIndex section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func verticalSpacing(forElementsInSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func horizontalSpacing(forElementsInSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
