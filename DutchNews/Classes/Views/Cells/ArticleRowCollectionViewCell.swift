//
//  ArticleRowCollectionViewCell.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit

class ArticleRowCollectionViewCell: HeadlineBaseCollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        sourceLabel.text = nil
        dateLabel.text = nil
        imageView.image = #imageLiteral(resourceName: "image-placeHolder")
        imageView.cancelCurrentImageLoad()
    }
    
    override func config(viewModel article: ArticleRepresentable) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        sourceLabel.text = article.source
        imageView.setImage(url: article.urlToImage)
        dateLabel.text = article.publishedAt
        super.config(viewModel: article)
    }
    
}
