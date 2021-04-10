//
//  UIView+Anchor.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/5.
//

import UIKit

protocol EdgeAble: AnyObject {
    var frame: CGRect { get set }

    var left: CGFloat { get set }

    var right: CGFloat { get set }

    var top: CGFloat { get set }

    var bottom: CGFloat { get set }
    
    var width: CGFloat { get set }
    
    var height: CGFloat { get set }

    var centerX: CGFloat { get set }

    var centerY: CGFloat { get set }

    var size: CGSize { get set }
}

extension EdgeAble {
    public var left: CGFloat {
        get {
            return frame.minX
        }
        set(left) {
            frame.origin.x = left
        }
    }

    public var right: CGFloat {
        get {
            return frame.maxX
        }

        set(right) {
            frame.origin.x = right - frame.size.width
        }
    }

    public var top: CGFloat {
        get {
            return frame.minY
        }

        set(top) {
            frame.origin.y = top
        }
    }

    public var bottom: CGFloat {
        get {
            return frame.maxY
        }

        set(bottom) {
            frame.origin.y = bottom - frame.size.height
        }
    }
    


    public var centerX: CGFloat {
        get {
            return frame.midX
        }

        set(centerX) {
            frame.origin.x = centerX - frame.size.width / 2
        }
    }

    public var centerY: CGFloat {
        get {
            return frame.midY
        }

        set(centerY) {
            frame.origin.y = centerY - frame.size.height / 2
        }
    }

    public var size: CGSize {
        get {
            return frame.size
        }

        set(size) {
            frame.size = size
        }
    }
}

// width和height写在这里是因为Neon中实现了width和height的getter
extension UIView: EdgeAble {
    public var width: CGFloat {
        get {
            return frame.size.width
        }

        set(width) {
            frame.size.width = width
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        }

        set(height) {
            frame.size.height = height
        }
    }
}

extension CALayer: EdgeAble {
    public var width: CGFloat {
        get {
            return frame.size.width
        }

        set(width) {
            frame.size.width = width
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        }

        set(height) {
            frame.size.height = height
        }
    }
}
