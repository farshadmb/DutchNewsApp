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
    
    deinit {
        viewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        viewModel?.output.asObservable().bind(onNext: {[weak self]  in
            self?.headerView.config(content: $0)
            self?.updateHeaderSize()
        }).disposed(by: disposeBag)
        
        viewModel?.buildURLContent()
            .observeOn(MainScheduler.asyncInstance)
            .bind(onNext: {[weak contentView] (request) in
                contentView?.load(request)
            }).disposed(by: disposeBag)
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.reload()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contentView.stopLoading()
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
    
    func updateHeaderSize() {
        
        headerView.layoutIfNeeded()
        
        let size = headerView.systemLayoutSizeFitting(headerView.bounds.size,
                                                      withHorizontalFittingPriority: .required,
                                                      verticalFittingPriority: .fittingSizeLevel)
        
        if let minHeight = headerView.titleLabel.superview?.bounds.height {
            containerScrollView.parallaxHeader.minimumHeight = minHeight + 16
        }
        
        let height = AVMakeRect(aspectRatio: CGSize(width: 16, height: 9),
                                insideRect: view.bounds).size.height
        
        containerScrollView.parallaxHeader.height = max(size.height, height)
        view.layoutIfNeeded()
        
    }
    
}
