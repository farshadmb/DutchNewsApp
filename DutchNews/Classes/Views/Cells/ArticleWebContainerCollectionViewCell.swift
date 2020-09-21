//
//  ArticleWebContainerCollectionViewCell.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit

class ArticleWebContainerCollectionViewCell: HeadlineBaseCollectionViewCell {
    
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.text = nil 
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
