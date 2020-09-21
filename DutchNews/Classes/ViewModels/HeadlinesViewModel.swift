//
//  HeadlinesViewModel.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class HeadlinesViewModel: ArticlesViewModel {
    
    private var statePublisher: BehaviorRelay<ViewModelState>
    
    var state: Driver<ViewModelState> {
        return statePublisher.asDriver {
            return .just(.error($0) )
        }.distinctUntilChanged()
    }
    
    private var outputPublisher: BehaviorRelay<[T]>
    
    var output: Driver<[T]> {
        outputPublisher.asDriver { _ in return .never() }
    }
    
    let useCase: HeadlinesUseCases
    
    let disposeBag = DisposeBag()
    
    private init(useCase: HeadlinesUseCases,
                 state: BehaviorRelay<ViewModelState>,
                 output: BehaviorRelay<[T]>) {
        
        self.useCase = useCase
        self.statePublisher = state
        self.outputPublisher = output
    }
    
    required convenience init(useCase: HeadlinesUseCases) {
        self.init(useCase: useCase,
                  state: .init(value: .idle),
                  output: .init(value: []))
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Article View Model Implementation
    // MARK: -
    ////////////////////////////////////////////////////////////////
    
    func fetchArticles() {
        fetchArticlesFromRepository()
    }
    
    func refreshArticles() {
        fetchArticlesFromRepository(isRefreshing: true)
    }
    
    func article(atIndex index: IndexPath) -> T.Item? {
        //TODO: Implement method
        return nil
    }
    
    func didSelect(article: T.Item) {
        //TODO: Implement method
    }
    
    func didSelect(articleAtIndex: IndexPath) {
        //TODO: Implement method
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Private Methods
    // MARK: -
    ////////////////////////////////////////////////////////////////
    
    func fetchArticlesFromRepository(isRefreshing: Bool = false) {
        statePublisher.accept(.loading(isRefreshing: isRefreshing))
        
        useCase.fetchArticles()
            .subscribe {[weak self] event in
                
                switch event {
                case .next(let items):
                    guard let `self` = self else {
                        break
                    }
                    
                    //                let mapped = newItems.map {
                    //                    ArticleViewModel(repository: $0, userRepositoryUseCases: AppDIContainer.userRepositoryUseCases)
                    //                }
                    //                .filter { item in
                    //                    !self.items.contains(where: { $0.model.id == item.model.id })
                    //                }
                    //                .reversed() as Array
                    //
                    //                self.items += mapped
                    //
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
