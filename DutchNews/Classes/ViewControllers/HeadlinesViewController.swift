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
    
    var layoutConfiguration: HeadlineLayoutConfiguration = ArticleHeadlineLayoutConfiguration() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let disposeBag = DisposeBag()
    
    lazy var dataSource: RxCollectionViewSectionedReloadDataSource<SectionType> = {
        return self.buildDataSource()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupLayouts()
        
        let items = self.buildMockData()
        Observable.from(optional: [items])
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        self.collectionView.delegate = self
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func setupLayouts() {
        setupColletionView()
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
    
}

extension HeadlinesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
