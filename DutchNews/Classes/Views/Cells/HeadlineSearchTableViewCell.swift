//
//  HeadlineSearchTableViewCell.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/26/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit
import Foundation
import MaterialComponents
import RxSwift

class HeadlineSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundCard: MDCCardCollectionCell!
    @IBOutlet weak var articleimageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var disposeBag: DisposeBag! = DisposeBag()
    
    deinit {
        disposeBag = nil
        backgroundCard = nil
    }
       
    override func awakeFromNib() {
        super.awakeFromNib()
        articleimageView.clipsToBounds = true
        articleimageView.layer.cornerRadius = 5.0
        
        backgroundCard?.isInteractable = false
        backgroundCard?.isSelectable = true
        backgroundCard?.setShadowElevation(.cardResting, for: .normal)
        
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
        disposeBag = DisposeBag()
        titleLabel.text = nil
        descriptionLabel.text = nil
        sourceLabel.text = nil
        dateLabel.text = nil
        articleimageView.image = #imageLiteral(resourceName: "image-placeHolder")
        articleimageView.cancelCurrentImageLoad()
    }
    
    func config(viewModel article: ArticleRepresentable) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        sourceLabel.text = article.source
        articleimageView.setImage(url: article.urlToImage)
        dateLabel.text = article.publishedAt
        
    }
    
}
