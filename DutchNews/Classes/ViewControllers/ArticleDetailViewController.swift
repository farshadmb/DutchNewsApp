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

class ArticleDetailViewController: UIViewController, AlertableView {
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.progress = 0
        view.progressTintColor = MDCPalette.blue.tint300
        return view
    }()
    
    lazy var contentView: WKWebView = {
        return WKWebView(forAutoLayout: ())
    }()
    
    lazy var headerView: ArticleDetailHeaderView = {
        let view = ArticleDetailHeaderView.fromNib()
        return view
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
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
        contentView.scrollView.parallaxHeader.view = headerView
        contentView.scrollView.parallaxHeader.mode = .topFill
        contentView.scrollView.parallaxHeader.minimumHeight = 70
        contentView.scrollView.parallaxHeader.height = 180
        headerView.backgroundColor = .cyan
    }
    
    func setupContentView() {
        view.addSubview(contentView)
        contentView.autoPinEdgesToSuperviewSafeArea()
    }
    
}
