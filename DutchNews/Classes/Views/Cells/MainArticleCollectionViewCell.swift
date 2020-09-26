//
//  MainArticleCollectionViewCell.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit
import AVFoundation
import MaterialComponents

class MainArticleCollectionViewCell: HeadlineBaseCollectionViewCell {

    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundCard?.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.cancelCurrentImageLoad()
        imageView.image = nil
        sourceLabel.text = nil
    }
    
    override func config(viewModel: ArticleRepresentable) {
        titleLabel.text = viewModel.title
        sourceLabel.text = viewModel.source
        imageView.setImage(url: viewModel.urlToImage)
        super.config(viewModel: viewModel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        Logger.debugLog("layoutSubviews Aspect ratio 16:9 => \(bounds.size)")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attribute = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        //make sure that aspect ratio applied on size calculation.
        let size = AVMakeRect(aspectRatio: CGSize(width: 16, height: 9),
                              insideRect: CGRect(origin: .zero, size: attribute.size)).size
        Logger.debugLog("preferredLayoutAttributes Aspect ratio 16:9 => \(size)")
        attribute.size.height = max(size.height, 180)
        return attribute
        
    }

}
