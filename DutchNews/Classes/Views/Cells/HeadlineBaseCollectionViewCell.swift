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
    
    open func config(viewModel: ArticleRepresentable) {
        
    }
    
}
