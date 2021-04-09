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
            var newFrame = frame
            newFrame.origin.x = left
            frame = newFrame
        }
    }

    public var right: CGFloat {
        get {
            return frame.maxX
        }

        set(right) {
            var newFrame = frame
            newFrame.origin.x = right - frame.size.width
            frame = newFrame
        }
    }

    public var top: CGFloat {
        get {
            return frame.minY
        }

        set(top) {
            var newFrame = frame
            newFrame.origin.y = top
            frame = newFrame
        }
    }

    public var bottom: CGFloat {
        get {
            return frame.maxY
        }

        set(bottom) {
            var newFrame = frame
            newFrame.origin.y = bottom - frame.size.height
            frame = newFrame
        }
    }

    public var centerX: CGFloat {
        get {
            return frame.midX
        }

        set(centerX) {
            var newFrame = frame
            newFrame.origin.x = centerX - frame.size.width / 2
            frame = newFrame
        }
    }

    public var centerY: CGFloat {
        get {
            return frame.midY
        }

        set(centerY) {
            var newFrame = frame
            newFrame.origin.y = centerY - frame.size.height / 2
            frame = newFrame
        }
    }

    public var size: CGSize {
        get {
            return frame.size
        }

        set(size) {
            var newFrame = frame
            newFrame.size = size
            frame = newFrame
        }
    }
}

extension UIView: EdgeAble {}

extension CALayer: EdgeAble {}
