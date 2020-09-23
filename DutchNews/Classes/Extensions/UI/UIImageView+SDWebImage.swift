//
//  UIImageView+SDWebImage.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    
    static let defaultSDWebImageOptions: SDWebImageOptions = [.lowPriority,.scaleDownLargeImages,.retryFailed,.refreshCached]
    static let cacheSDWebImageOptions: SDWebImageOptions = [.lowPriority,.scaleDownLargeImages,.queryMemoryData,.refreshCached]
    
    func setImage(url: URL?,placeHolderImage: UIImage? = #imageLiteral(resourceName: "image-placeHolder"),
                   options: SDWebImageOptions = UIImageView.defaultSDWebImageOptions,
                   completed: SDExternalCompletionBlock? = nil) {
        self.contentMode = .scaleAspectFill
        self.sd_setImage(with: url, placeholderImage: placeHolderImage,
                         options: options, completed: completed)
    }
    
    func cancelCurrentImageLoad() {
        sd_cancelCurrentImageLoad()
    }
    
}
