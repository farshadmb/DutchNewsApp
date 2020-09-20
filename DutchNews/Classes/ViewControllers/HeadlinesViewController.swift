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

class HeadlinesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionLayout: MagazineLayout? {
        return collectionView?.collectionViewLayout as? MagazineLayout
    }
    
    var layoutConfiguration : HeadlineLayoutConfiguration = ArticleHeadlineLayoutConfiguration() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(MagazineLayoutCollectionViewCell.self, forCellWithReuseIdentifier: "MyCustomCellReuseIdentifier")
        
        // Do any additional setup after loading the view.
        
        Observable.from(optional: Array(repeating: 20, count: 10))
            .bind(to: collectionView.rx.items(cellIdentifier: "MyCustomCellReuseIdentifier", cellType: MagazineLayoutCollectionViewCell.self)) { model, index, cell in
                cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
                cell.contentView.layer.borderWidth = 0.25
                cell.contentView.layer.cornerRadius = 5.0
                
        }.disposed(by: disposeBag)
        
        collectionView.delegate = self
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension HeadlinesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
