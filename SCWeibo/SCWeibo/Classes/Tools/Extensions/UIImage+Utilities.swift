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

    public func compressImage(to targetSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        base.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let targetImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return targetImage
    }
}
