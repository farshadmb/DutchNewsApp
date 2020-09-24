//
//  ViewControllerFactory.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/25/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerFactory: class {
    
    func makeRootViewController() -> UINavigationController?
    func makeHeadlinesViewController() throws -> HeadlinesViewController
    func makePageViewController(selected: Int) throws -> ArticlePageViewController
    func makeArticleDetailViewController() throws -> ArticleDetailViewController
    
}

protocol ViewControllerFactoryable {
    var controllerFactory: ViewControllerFactory? { get set }
}
