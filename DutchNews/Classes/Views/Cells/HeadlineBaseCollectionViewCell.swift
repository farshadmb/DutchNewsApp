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

class HeadlineBaseCollectionViewCell: MagazineLayoutCollectionViewCell {
    
    var disposeBag: DisposeBag! = DisposeBag()
    
    deinit {
        disposeBag = nil
    }
    
    override func prepareForReuse() {
        super.awakeFromNib()
        disposeBag = nil
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = false
    }
    
    open func config(viewModel: ArticleRepresentable) {
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        contentView.bounds = layoutAttributes.bounds
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        contentView.layoutIfNeeded()
        
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        let size: CGSize
        
        if (attributes as? MagazineLayoutCollectionViewLayoutAttributes)?.shouldVerticallySelfSize == true {
            // Self-sizing is required in the vertical dimension.
            layoutIfNeeded()
            size = super.systemLayoutSizeFitting(
                layoutAttributes.size,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .required)
        } else {
            // No self-sizing is required; respect whatever size the layout determined.
            size = layoutAttributes.size
        }
        
        layoutAttributes.size = size
        
        return layoutAttributes
    }
    
}
