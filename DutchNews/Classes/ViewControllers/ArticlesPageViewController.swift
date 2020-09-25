//
//  ArticlesPageViewController.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/23/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import Pageboy
import RxSwift
import RxCocoa

class ArticlePageViewController: PageboyViewController, AlertableView, ViewControllerFactoryable {
    
    var viewModel: ArticlesPageViewModel?
    
    private var selectedIndex = 0
    
    let disposeBag = DisposeBag()
    
    var controllerFactory: ViewControllerFactory?
    
    deinit {
        viewModel = nil
        controllerFactory = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interPageSpacing = 8.0
        self.dataSource = self
        
        bindViewModel()
        loadContentsIfNeeded()
        // Do any additional setup after loading the view.
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func updateLayouts(onState state: ViewModelState) {
        switch state {
            
        case .loaded:
            self.reloadData()
        case .error(let error):
            
            let message: String
            if let err = error as? URLError {
                message = err.localizedDescription
            }else {
                message = error.localizedDescription
            }
            
            presentAlertView(withMessage: message,
                             actionTitle: "retry".localized) {[weak self] in
                                self?.loadContentsIfNeeded()
            }
        default:
            break
        }
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: ViewModel
    // MARK: -
    ////////////////////////////////////////////////////////////////
    
    func bindViewModel() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        bind(viewModel: viewModel)
    }
    
    func bind(viewModel: ArticlesPageViewModel) {
        
        viewModel.selectedIndex.asDriver()
            .drive(onNext: {[weak self] in
                self?.selectedIndex = $0 ?? 0
            }).disposed(by: disposeBag)
        
        viewModel.state.drive(onNext: {[weak self] (state) in
            self?.updateLayouts(onState: state)
        }).disposed(by: disposeBag)
        
    }
    
    func loadContentsIfNeeded() {
        viewModel?.fetchArticles()
    }
    
}

extension ArticlePageViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewModel?.count ?? 0
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        guard let vc = try? controllerFactory?.makeArticleDetailViewController() else {
            return nil
        }
        
        vc.viewModel = viewModel?[index]
        
        return vc
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: selectedIndex)
    }
    
}
