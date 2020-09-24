//
//  ArticleDetailViewController.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/23/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import WebKit
import MaterialComponents.MaterialColor
import MXParallaxHeader
import AVFoundation

class ArticleDetailViewController: UIViewController, AlertableView {
    
    @IBOutlet weak var containerScrollView: UIScrollView!
    @IBOutlet weak var contentView: WKWebView!
    
    lazy var headerView: ArticleDetailHeaderView = {
        let view = ArticleDetailHeaderView.fromNib()
        return view
    }()
    
    var viewModel: ArticleViewModel?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        contentView.load(URLRequest(url: URL(string: "https://news.google.com/topstories?hl=en-US&gl=US&ceid=US:en")!))
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

    func setupViews() {
        setupContentView()
        setupHeaderView()
    }
    
    func setupHeaderView() {
        containerScrollView.parallaxHeader.view = headerView
        containerScrollView.parallaxHeader.mode = .fill
        containerScrollView.parallaxHeader.minimumHeight = 70
        
        let height = AVMakeRect(aspectRatio: CGSize(width: 16, height: 9),
                                insideRect: view.bounds).size.height
        
        containerScrollView.parallaxHeader.height = height
    }
    
    func setupContentView() {
//        contentView.scrollView.isScrollEnabled = true
//        contentView.scrollView.rx.observe(CGSize.self, #keyPath(UIScrollView.contentSize),
//                                          options: [.initial,.new], retainSelf: false)
//            .filter { $0 != nil }.map { $0! }
//            .distinctUntilChanged()
//            .bind {[weak self ] (size) in
//                self?.contentView.autoSetDimension(.height, toSize: size.height)
//                self?.view.layoutIfNeeded()
//            }
        
    }
    
}
