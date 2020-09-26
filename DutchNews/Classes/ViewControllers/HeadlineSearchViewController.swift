//
//  HeadlineSearchViewController.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/26/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import PureLayout
import MaterialComponents

class HeadlineSearchViewController: UIViewController, AlertableView {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadingIndicator: MDCProgressView!
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionType> = {
        return self.buildDataSource()
    }()
    
    var viewModel: ArticlesSearchViewModel?
    
    weak var searchController: UISearchController?
    
    var controllerFactory: ViewControllerFactory?
    
    var inSearching: Bool {
        (searchController?.isActive ?? false) &&
            !(searchController?.searchBar.text.isEmpty ?? true)
    }
    
    deinit {
        viewModel = nil
        searchController = nil
        controllerFactory = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        bindViewModel()
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
    
    ////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: UI Methods
    // MARK: -
    ////////////////////////////////////////////////////////////////
    func setupLayouts() {
        setupTableView()
        
        loadingIndicator.mode = .indeterminate
        loadingIndicator.trackTintColor = .clear
        loadingIndicator.progressTintColor = .black
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        
    }
    
    fileprivate static let cellId = "ResultCellId"
    
    func setupTableView() {
        tableView.register(HeadlineSearchTableViewCell.nib(), forCellReuseIdentifier: Self.cellId)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.separatorColor = nil
    }
    
    func updateLayoutsBase(onState state: ViewModelState) {
        switch state {
        case .loading(isRefreshing: let isRefreshing) where isRefreshing == false :
            loadingIndicator.startAnimating()
            loadingIndicator.isHidden = false
            
        case .loaded:
            
            if dataSource.sectionModels.flatMap({ $0.items }).count == 0, inSearching {
                presentAlertView(withMessage: "no_result_found".localized)
            }
            
            fallthrough
        case .idle:
            
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            
        case .error(let error):
            loadingIndicator.stopAnimating()
            
            let message: String
            if let err = error as? URLError {
                message = err.localizedDescription
            }else {
                message = error.localizedDescription
            }
            
            presentAlertView(withMessage: message,
                             actionTitle: "retry".localized) {[weak self] in
                                self?.searchAgain()
            }
        default:
            break
        }
    }
    
    /////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: View Model Methods
    // MARK: -
    ////////////////////////////////////////////////////////////////
    
    func bindViewModel() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        bind(viewModel: viewModel)
    }
    
    func bind(viewModel: ArticlesSearchViewModel) {
        
        viewModel.output.map {
            return $0.map { SectionType(model: "search_result_title", items: $0.items) }
        } .drive(tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.bind {[weak viewModel] (indexPath) in
            viewModel?.didSelect(articleAtIndex: indexPath)
        }.disposed(by: disposeBag)
        
        viewModel.state.drive(onNext: {[weak self] (state) in
            self?.updateLayoutsBase(onState: state)
        }).disposed(by: disposeBag)
        
        searchController?.searchBar.rx.text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(onNext: {[weak viewModel] (keyword) in
                viewModel?.searchArticles(keyword: keyword ?? "")
            }).disposed(by: disposeBag)
        
        searchController?.searchBar.rx.cancelButtonClicked.bind(onNext: { [weak viewModel] in
            viewModel?.searchArticles(keyword: "")
        }).disposed(by: disposeBag)
        
        viewModel.selectedItem.observeOn(MainScheduler.instance)
            .filter { $0 != nil }.map { $0! }
            .bind {[weak self] in
                self?.navigateToDetail(with: $0)
            }.disposed(by: disposeBag)
    }
    
}

extension HeadlineSearchViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

////////////////////////////////////////////////////////////////
// MARK: -
// MARK: Helper Methods
// MARK: -
////////////////////////////////////////////////////////////////

extension HeadlineSearchViewController {
    
    typealias SectionType = ArticlesSearchViewModel.T
    
    func buildDataSource() -> RxTableViewSectionedReloadDataSource<SectionType> {
        
        return .init(configureCell: {[weak self] (_, tableView, indexPath, viewModel) -> UITableViewCell in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellId,
                                                           for: indexPath) as? HeadlineSearchTableViewCell else {
                    return UITableViewCell()
                }
                
                self?.config(cell: cell, viewModel: viewModel)
                return cell
            },
                     titleForHeaderInSection: { (dataSource, section) -> String? in
                        dataSource[section].model.localized
        })
    }
    
    private func config(cell: HeadlineSearchTableViewCell,
                        viewModel: ArticleViewModel) {
        
        viewModel.output
            .drive(onNext: {[weak cell] viewModel in
                cell?.config(viewModel: viewModel)
            }).disposed(by: cell.disposeBag)
        
    }
    
    func search(keyword: String?) {
        viewModel?.searchArticles(keyword: keyword ?? "")
    }
    
    func searchAgain() {
        self.search(keyword: searchController?.searchBar.text)
    }
    
    func navigateToDetail(with viewModel: ArticleViewModel) {
        do {
            guard let vc = try controllerFactory?.makeArticleDetailViewController() else {
                return
            }
            
            vc.viewModel = viewModel
            
            self.presentingViewController?.navigationController?.show(vc, sender: false)
            
        }catch {
            presentAlertView(withMessage: error.localizedDescription)
        }
    }
    
}
