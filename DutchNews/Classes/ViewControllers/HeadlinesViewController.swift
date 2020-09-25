//
//  HeadlinesViewController.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit
import MagazineLayout
import RxCocoa
import RxSwift
import RxDataSources
import PureLayout

class HeadlinesViewController: UIViewController {
    
    enum HeadlinesCellIdentifier: String {
        case main
        case halfWidth
        case web
        case row
        
        var id: String {
            return self.rawValue
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionLayout: MagazineLayout? {
        return collectionView?.collectionViewLayout as? MagazineLayout
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        return refreshControl
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .large)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()
    
    var layoutConfiguration: HeadlineLayoutConfiguration = ArticleHeadlineLayoutConfiguration() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource: RxHeadlinesDataSource<SectionType> = {
        return self.buildDataSource()
    }()
    
    var viewModel: ArticlesViewModel? = HeadlinesViewModel(useCase: AppDIContainer.headlineFetchingUseCase)
    
    var controllerFactory: ViewControllerFactory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupLayouts()
        
        bindViewModels()
        loadContentsIfNeeded()
        
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
        setupColletionView()
        view.addSubview(loadingIndicator)
        loadingIndicator.autoCenterInSuperview()
        if #available(iOS 13, *) {
            loadingIndicator.tintColor = UIColor.label
        }else {
            loadingIndicator.tintColor = .red
        }
        
        loadingIndicator.hidesWhenStopped = true
        
    }
    
    func setupColletionView() {
        
        collectionView.register(MainArticleCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: HeadlinesCellIdentifier.main.id)
        collectionView.register(ArticleRowCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: HeadlinesCellIdentifier.row.id)
        collectionView.register(HalfWidthArticleCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: HeadlinesCellIdentifier.halfWidth.id)
        collectionView.register(ArticleWebContainerCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: HeadlinesCellIdentifier.web.id)
        
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        
    }
    
    func updateLayoutsBase(onState state: ViewModelState) {
        switch state {
        case .loading(isRefreshing: let isRefreshing) where isRefreshing == false :
            loadingIndicator.stopAnimating()
           
        case .loaded:
            guard refreshControl.isRefreshing else {
                fallthrough
            }
            refreshControl.endRefreshing()
            fallthrough
        case .idle:
            loadingIndicator.stopAnimating()
            
        case .error(let error):
            refreshControl.endRefreshing()
            loadingIndicator.stopAnimating()
            
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
    // MARK: View Model Methods
    // MARK: -
    ////////////////////////////////////////////////////////////////
    
    func bindViewModels() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        bind(viewModel: viewModel)
    }
    
    func bind(viewModel: ArticlesViewModel) {
        
        viewModel.output.drive(collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        // RxSwift assigned another delelgate object after running the upper code
        // we have to make sure that current vc present as delegate
        collectionView.delegate = self
        collectionView.reloadData()
        
        viewModel.state.drive(onNext: {[weak self] (state) in
            self?.updateLayoutsBase(onState: state)
        }).disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind { [weak self] _ in
                self?.loadContentsIfNeeded()
            }.disposed(by: disposeBag)
        
        viewModel.selectedIndex.observeOn(MainScheduler.instance)
            .filter { $0 != nil }.map { $0! }
            .bind {[weak self] in
                
                self?.navigateToPages(withIndex: $0)
                
            }.disposed(by: disposeBag)
    }
    
    func loadContentsIfNeeded() {
        guard refreshControl.isRefreshing else {
            viewModel?.fetchArticles()
            return
        }
        
        viewModel?.refreshArticles()
    }
    
    func navigateToPages(withIndex index: Int) {
        do {
            guard let vc = try controllerFactory?.makePageViewController(selected: index) else {
                return
            }
            
            self.navigationController?.show(vc, sender: false)
            
        }catch {
            presentAlertView(withMessage: error.localizedDescription)
        }
    }
    
}

extension HeadlinesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let item = dataSource[indexPath]
        viewModel?.didSelect(article: item)
        
    }
}

extension HeadlinesViewController: AlertableView {}
extension HeadlinesViewController: ViewControllerFactoryable {}
