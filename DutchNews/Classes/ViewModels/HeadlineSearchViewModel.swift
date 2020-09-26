//
//  HeadlineSearchViewModel.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class HeadlineSearchViewModel: ArticlesSearchViewModel {
    
    var selectedIndex: BehaviorRelay<Int?>
    
    private(set) var selectedItem: BehaviorRelay<ArticleViewModel?> = BehaviorRelay(value: nil)
    
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
    
    func searchArticles(keyword: String) {
        searchFromRepository(keyword: keyword)
    }
    
    func fetchArticles() {
        
    }
    
    func refreshArticles() {
        
    }
    
    func didSelect(article: T.Item) {
        let datas = items
        
        guard let index = datas.firstIndex(where: { $0 == article }),
            index != 3 else {
                return
        }
        
        self.selectedIndex.accept(index)
        self.selectedItem.accept(article)
    }
    
    func didSelect(articleAtIndex index: IndexPath) {
        let datas = items
        guard datas[safe:index.item] != nil else {
            return
        }
        self.selectedIndex.accept(index.item)
        self.selectedItem.accept(datas[safe:index.item])
    }
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Private Methods
    // MARK: -
    ////////////////////////////////////////////////////////////////
    
    func searchFromRepository(keyword: String) {
        
        statePublisher.accept(.loading(isRefreshing: false))
        
        useCase.searchInArticle(keyword: keyword)
            .subscribe {[weak self] event in
                
                switch event {
                case .next(let newItems):
                    guard let `self` = self else {
                        break
                    }
                    
                    let mapped = newItems.map {
                        HeadlineCellViewModel(model: $0)
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
