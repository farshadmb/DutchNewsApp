//
//  ViewModelViewControllerFactory.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/25/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

final class ViewModelViewControllerFactory: ViewControllerFactory {
    
    enum Error: Swift.Error {
        case notFound
    }
    
    let storyboard: UIStoryboard
    
    init(storyboard: UIStoryboard) {
        self.storyboard = storyboard
    }
    
    func makeRootViewController() -> UINavigationController? {
        return self.storyboard.instantiateInitialViewController() as? UINavigationController
    }
    
    func makeHeadlinesViewController() throws -> HeadlinesViewController {
        
        guard let vc: HeadlinesViewController = makeViewController(forScreen: ScreenName.headlines) else {
            throw Error.notFound
        }
        
        vc.viewModel = AppDIContainer.headlinesViewModel
        vc.controllerFactory = self
        
        return vc
    }
    
    func makePageViewController(selected: Int) throws -> ArticlePageViewController {
        guard let vc: ArticlePageViewController = makeViewController(forScreen: ScreenName.pages) else {
            throw Error.notFound
        }
        
        vc.viewModel = AppDIContainer.articlePagesViewModel
        vc.viewModel?.selectedIndex.accept(selected)
        vc.controllerFactory = self
        
        return vc
    }
    
    func makeArticleDetailViewController() throws -> ArticleDetailViewController {
        guard let vc: ArticleDetailViewController = makeViewController(forScreen: ScreenName.detail) else {
            throw Error.notFound
        }
        
        return vc
    }
    
    private func makeViewController<T: UIViewController>(forScreen screen: Screen) -> T? {
        
        guard let vc = storyboard.instantiateViewController(identifier: screen.screenIdentifier()) as? T else {
            return nil
        }
        
        return vc
    }
    
}
