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
    
    var selectedIndex: BehaviorRelay<Int?>
    
    private var statePublisher: BehaviorRelay<ViewModelState>
    
    var state: Driver<ViewModelState> {
        return statePublisher.asDriver {
            return .just(.error($0) )
        }.distinctUntilChanged()
    }
    
    private var outputPublisher: BehaviorRelay<[T]>
    
    private var items: [T.Item] = [] {
        didSet {
            outputPublisher.accept([T(model: "Headlines", items: items)])
        }
    }
    
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
        self.selectedIndex = BehaviorRelay<Int?>(value: nil)
        
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
    
    func didSelect(article: T.Item) {
        let datas = items
        guard var index = datas.firstIndex(where: { $0 == article }),
            index != 3 else {
            return
        }
        
        if index > 3 {
            index -= 1
        }
        
        self.selectedIndex.accept(index)
    }
    
    func didSelect(articleAtIndex index: IndexPath) {
        let datas = items
        
        // make mutable.
        
        var index = index
        guard index.item != 3, datas[safe:index.item] != nil else {
             return
        }
        
        if index.item > 3 {
            index.item -= 1
        }
        
        self.selectedIndex.accept(index.item)
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
                case .next(let newItems):
                    guard let `self` = self else {
                        break
                    }
                    
                    var mapped = newItems.map {
                        HeadlineCellViewModel(model: $0)
                    }
                    
                    guard case let .loading(isRefreshing:isRefreshing) = self.statePublisher.value,
                        isRefreshing == true else {
                            
                            if mapped.count > 3 {
                                mapped.insert(HeadlineCellViewModel(model: Article.htmlArticle()),
                                                  at: 3)
                            }
                            self.items = mapped
                            self.statePublisher.accept(.loaded)
                            return
                    }
                    
                    let output = mapped.filter { viewModel in
                            !self.items.contains(where: { $0 == viewModel })
                    }
                    
                    var result = output + self.items.filter({ $0.model.type == .news })
                    
                    if result.count > 3 {
                        result.insert(HeadlineCellViewModel(model: Article.htmlArticle()),
                                          at: 3)
                    }
                    self.items = result
                    
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
