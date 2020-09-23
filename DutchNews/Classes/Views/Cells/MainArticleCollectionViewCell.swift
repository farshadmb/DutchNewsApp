//
//  MainArticleCollectionViewCell.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit
import AVFoundation

class MainArticleCollectionViewCell: HeadlineBaseCollectionViewCell {

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.clipsToBounds = true
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
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attribute = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        //make sure that aspect ratio applied on size calculation.
        let size = AVMakeRect(aspectRatio: CGSize(width: 16, height: 9),
                   insideRect: attribute.bounds).size
        
        attribute.size = size
        return attribute
        
    }

}
