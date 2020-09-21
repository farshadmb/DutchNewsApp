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
        webView.autoPinEdgesToSuperviewSafeArea()
        webView.scrollView.isScrollEnabled = false
        contentLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        layoutAttributes.size.height = max(webView.scrollView.contentSize.height, 44.0)
        Logger.debugLog("Height \(layoutAttributes.size.height)")
        return layoutAttributes
    }
    
}

extension Reactive where Base: ArticleWebContainerCollectionViewCell {
    
    var didLoadContent: ControlEvent<Void> {
        let source = self.base.webView.rx.didFinishLoad.map { _ in () }
        return ControlEvent(events: source)
    }
    
}
