//
//  ScreenEnum.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/25/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

enum ScreenName: Screen {
    
    case headlines
    case pages
    case detail
    
    func screenIdentifier() -> String {
        switch self {
        case .headlines:
            return HeadlinesViewController.className
        case .pages:
            return ArticlePageViewController.className
        case .detail:
            return ArticleDetailViewController.className
        }
    }
    
}
