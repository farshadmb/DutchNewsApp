//
//  HalfWidthArticleCollectionViewCell.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit

class HalfWidthArticleCollectionViewCell: HeadlineBaseCollectionViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        imageView.image = nil
        sourceLabel.text = nil
        imageView.cancelCurrentImageLoad()
    }
    
    override func config(viewModel article: ArticleRepresentable) {
        
        titleLabel.text = article.title
        sourceLabel.text = article.source
        imageView.setImage(url: article.urlToImage)
        
    }
    
}
