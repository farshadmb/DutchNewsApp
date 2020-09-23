//
//  UIImage+Additionals.swift
//  DutchNews
//
//  Created by Farshad Mousalou on 9/21/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation
import UIKit

protocol OptionalImage {
    
}

extension UIImage: OptionalImage {
    
}

extension Optional where Wrapped: OptionalImage {
    
    var isEmpty: Bool {
        return UIImage.isEmpty(self as? UIImage)
    }
    
}

public enum UIImageContentMode {
    case scaleToFill, scaleAspectFit, scaleAspectFill
}

extension UIImage {
    
    static func isEmpty(_ aImage: UIImage?) -> Bool {
        
        guard let image = aImage else {
            return true
        }
        
        return image.isEmpty
    }
    
    var isEmpty: Bool {
        return self.size == .zero
    }
    
    func resize(toSize: CGSize, contentMode: UIImageContentMode = .scaleToFill) -> UIImage? {
        let horizontalRatio = size.width / self.size.width
        let verticalRatio = size.height / self.size.height
        var ratio: CGFloat!
        
        switch contentMode {
        case .scaleToFill:
            ratio = 1
        case .scaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)
        
        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let transform = CGAffineTransform.identity
        
        // Rotate and/or flip the image if required by its orientation
        context?.concatenate(transform)
        
        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality(rawValue: 3)!
        
        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))
        
        // Draw into the context; this scales the image
        context?.draw(self.cgImage!, in: rect)
        
        // Get the resized image from the context and a UIImage
        let newImage = UIImage(cgImage: (context?.makeImage()!)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage
    }
    
}

extension UIImage {
    
    ///  Returns base64 string
    var base64: String {
        return jpegData(compressionQuality: 1.0)!.base64EncodedString()
    }
    
    ///  Returns compressed image to rate from 0 to 1
    func compressImage(rate: CGFloat) -> Data? {
        return jpegData(compressionQuality: rate)
    }
    
    ///  Returns Image size in Bytes
    func getSizeAsBytes() -> Int {
        return jpegData(compressionQuality: 1.0)?.count ?? 0
    }
    
    ///  Returns Image size in Kylobites
    func getSizeAsKilobytes() -> Int {
        let sizeAsBytes = getSizeAsBytes()
        return sizeAsBytes != 0 ? sizeAsBytes / 1024 : 0
    }
    
    ///  scales image
    // swiftlint:disable:next identifier_name
    class func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
        let newSize = CGSize(width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// Returns resized image with width. Might return low quality
    func resizeWithWidth(_ width: CGFloat) -> UIImage {
        let aspectSize = CGSize(width: width, height: aspectHeightForWidth(width))
        
        UIGraphicsBeginImageContextWithOptions(aspectSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    /// Returns resized image with height. Might return low quality
    func resizeWithHeight(_ height: CGFloat) -> UIImage {
        let aspectSize = CGSize(width: aspectWidthForHeight(height), height: height)
        
//        UIGraphicsBeginImageContext(aspectSize)
        UIGraphicsBeginImageContextWithOptions(aspectSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    
    func aspectWidthForHeight(_ height: CGFloat) -> CGFloat {
        return (height * self.size.width) / self.size.height
    }
    
    func croppedImage(_ bound: CGRect) -> UIImage? {
        guard self.size.width > bound.origin.x else {
            Logger.errorLog(": Your cropping X coordinate is larger than the image width", tag: "\(#function) \(#line)")
            return nil
        }
        
        guard self.size.height > bound.origin.y else {
            Logger.errorLog(": Your cropping Y coordinate is larger than the image height", tag: "\(#function) \(#line)")
            return nil
        }
        
        let scaledBounds = CGRect(x: bound.minX * self.scale, y: bound.midY * self.scale, width: bound.width * self.scale, height: bound.height * self.scale)
        
        let imageRef = self.cgImage?.cropping(to: scaledBounds)
        let croppedImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImage.Orientation.up)
        return croppedImage
    }
    
    ///  Use current image for pattern of color
    func withColor(_ tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        context?.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// Returns the image associated with the URL
    convenience init?(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.init(data: Data())
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            self.init(data: Data())
            return
        }
        self.init(data: data)
    }
    
    class func blankImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, UIScreen.main.scale)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIImage {
    
    /// SwifterSwift: Size in bytes of UIImage
    var bytesSize: Int {
        return jpegData(compressionQuality: 1.0)?.count ?? 0
    }
    
    /// SwifterSwift: Size in kilo bytes of UIImage
    var kilobytesSize: Int {
        return bytesSize / 1024
    }
    
    /// SwifterSwift: UIImage with .alwaysOriginal rendering mode.
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /// SwifterSwift: UIImage with .alwaysTemplate rendering mode.
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
}

// MARK: - Methods
extension UIImage {
    
    /// SwifterSwift: Compressed UIImage from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional UIImage (if applicable).
    func compressed(quality: CGFloat = 0.5) -> UIImage? {
        guard let data = compressedData(quality: quality) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    /// SwifterSwift: Compressed UIImage data from original UIImage.
    ///
    /// - Parameter quality: The quality of the resulting JPEG image, expressed as a value from 0.0 to 1.0. The value 0.0 represents the maximum compression (or lowest quality) while the value 1.0 represents the least compression (or best quality), (default is 0.5).
    /// - Returns: optional Data (if applicable).
    func compressedData(quality: CGFloat = 0.5) -> Data? {
        return jpegData(compressionQuality: quality)
    }
    
    /// SwifterSwift: UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.height < size.height && rect.size.height < size.height else {
            return self
        }
        guard let image: CGImage = cgImage?.cropping(to: rect) else {
            return self
        }
        return UIImage(cgImage: image)
    }
    
    /// SwifterSwift: UIImage scaled to height with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - orientation: optional UIImage orientation (default is nil).
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, with orientation: UIImage.Orientation? = nil) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), false, UIScreen.main.scale)
//        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: toHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage scaled to width with respect to aspect ratio.
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - orientation: optional UIImage orientation (default is nil).
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, with orientation: UIImage.Orientation? = nil) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), false, UIScreen.main.scale)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage filled with color
    ///
    /// - Parameter color: color to fill image with.
    /// - Returns: UIImage filled with given color.
    func filled(withColor color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let mask = self.cgImage else {
            return self
        }
        context.clip(to: rect, mask: mask)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// SwifterSwift: UIImage tinted with color
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint
    /// - Returns: UIImage tinted with given color.
    func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        context!.clip(to: drawRect, mask: cgImage!)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}

// MARK: - Initializers
extension UIImage {
    
    /// SwifterSwift: Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        guard let aCgImage = image.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    
}
