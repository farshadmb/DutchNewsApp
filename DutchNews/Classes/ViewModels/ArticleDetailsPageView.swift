//
//  ArticleDetailsPageView.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/24/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ArticleDetailsPageView: ArticlesPageViewModel {
    
    private var statePublisher: BehaviorRelay<ViewModelState>
    
    var state: Driver<ViewModelState> {
        return statePublisher.asDriver {
            return .just(.error($0) )
        }.distinctUntilChanged()
    }
    
    private var items: [T.Item] = [] {
        didSet {
            
        }
    }
    
    var count: Int {
        return items.count
    }
    
    var selectedIndex: BehaviorRelay<Int?>
    
    var currentLoadingProgress: BehaviorRelay<CGFloat>
    
    let useCase: ArticlesUseCase
    
    let disposeBag = DisposeBag()
    
    init(useCase: ArticlesUseCase) {
        self.useCase = useCase
        self.selectedIndex = .init(value: 0)
        self.currentLoadingProgress = .init(value: 0.0)
        self.statePublisher = BehaviorRelay<ViewModelState>(value: .idle)
    }
    
    func viewModel(atIndex index: Int) -> T.Item? {
        
        guard let item = items[safe: index] else {
            return nil
        }
        
        return item
    }
    
    subscript(index: Int) -> T.Item? {
        return viewModel(atIndex: index)
    }
    
    func fetchArticles() {
        
        statePublisher.accept(.loading(isRefreshing: false))
        
        useCase.fetchLocalArticles()
            .subscribe {[weak self] event in
                
                switch event {
                case .next(let newItems):
                    guard let `self` = self else {
                        break
                    }
                    
                    let mapped = newItems.map {
                        ArticleDetailViewModel(model: $0)
                    }
                    
                    self.items = mapped
                    
                    self.statePublisher.accept(.loaded)
                    
                case .error(let error):
                    self?.statePublisher.accept(.error(error))
                    self?.statePublisher.accept(.idle)
                case .completed:
                    self?.statePublisher.accept(.idle)
                }
                
            }.disposed(by: disposeBag)
    }
    
}
