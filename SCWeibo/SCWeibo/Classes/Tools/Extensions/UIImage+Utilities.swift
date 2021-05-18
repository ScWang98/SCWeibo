//
//  UIImage+Utilities.swift
//  SCWeibo
//
//  Created by scwang on 2020/3/27.
//

import UIKit

extension UIImage: UtilitiesWrapperable {}

extension UtilitiesWrapper where Base: UIImage {
    public func image(tintColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.size, false, 0.0)
        tintColor.setFill()
        let bounds = CGRect(origin: CGPoint.zero, size: base.size)
        UIRectFill(bounds)
        base.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
    public static func image(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    public func compressImage(to targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        base.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let targetImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return targetImage
    }
}
