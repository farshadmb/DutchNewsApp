//
//  ArticleWebContainerCollectionViewCell.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit
import WebKit
import PureLayout
import RxCocoa
import RxSwift

class ArticleWebContainerCollectionViewCell: HeadlineBaseCollectionViewCell {
    
    @IBOutlet var contentLabel: UILabel!
    
    lazy var webView = WKWebView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.text = nil
        contentView.addSubview(webView)
        
        webView.scrollView.isScrollEnabled = false
        contentLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = contentView.bounds
    }
    
}

extension Reactive where Base: ArticleWebContainerCollectionViewCell {
    
    var didLoadContent: ControlEvent<Void> {
        let source = self.base.webView.rx.didFinishLoad.map { _ in () }
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
        return ControlEvent(events: source)
    }
    
}
