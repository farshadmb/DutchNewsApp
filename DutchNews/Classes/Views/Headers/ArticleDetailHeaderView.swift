//
//  ArticleDetailHeaderView.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/23/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleDetailHeaderView: UIView {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundImageView.image = #imageLiteral(resourceName: "image-placeHolder")
        // Initialization code
    }
    
    func config(content article: ArticleRepresentable) {
        
        titleLabel.text = article.title
        sourceLabel.text = article.source
        publishDateLabel.text = article.publishedAt
        
        backgroundImageView.setImage(url: article.urlToImage, contentMode: .scaleAspectFill)
        layoutIfNeeded()
    }
    
}
