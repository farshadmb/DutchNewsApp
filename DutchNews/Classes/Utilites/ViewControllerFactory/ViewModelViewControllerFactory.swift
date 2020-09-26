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
        vc.searchController = try? makeHeadlinesSearchViewController()
        
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
    
    func makeHeadlinesSearchViewController() throws -> UISearchController {
        
        guard let vc: HeadlineSearchViewController = makeViewController(forScreen: ScreenName.search) else {
            throw Error.notFound
        }
        
        vc.viewModel = AppDIContainer.headlineSearchViewModel
        vc.controllerFactory = self
        
        let searchController = UISearchController(searchResultsController: vc)
        vc.searchController = searchController
        searchController.searchResultsUpdater = vc
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "search_headline_title".localized
        
        return searchController
    }
    
    private func makeViewController<T: UIViewController>(forScreen screen: Screen) -> T? {
        
        guard let vc = storyboard.instantiateViewController(identifier: screen.screenIdentifier()) as? T else {
            return nil
        }
        
        return vc
    }
    
}
