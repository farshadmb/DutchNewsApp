//
//  HeadlineBaseCollectionViewCell.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import MagazineLayout
import RxSwift
import UIKit
import MaterialComponents

class HeadlineBaseCollectionViewCell: MagazineLayoutCollectionViewCell {
    
    var disposeBag: DisposeBag! = DisposeBag()
    
    @IBOutlet var backgroundCard: MDCCardCollectionCell?
    
    deinit {
        disposeBag = nil
        backgroundCard = nil
    }
    
    override func prepareForReuse() {
        super.awakeFromNib()
        disposeBag = nil
        disposeBag = DisposeBag()
    }
    
    fileprivate func setupBackgroundView() {
        
        if backgroundCard == nil {
            let view = MDCCardCollectionCell(forAutoLayout: ())
            contentView.insertSubview(view, at: 0)
            self.backgroundCard = view
        }
        
        backgroundCard?.isInteractable = false
        backgroundCard?.isSelectable = true
        backgroundCard?.setShadowElevation(.cardResting, for: .normal)
        
        backgroundCard?.autoPinEdgesToSuperviewEdges()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = false

        setupBackgroundView()
    }
    
    open func config(viewModel: ArticleRepresentable) {
        contentView.layoutIfNeeded()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        contentView.bounds = layoutAttributes.bounds
    }
}
