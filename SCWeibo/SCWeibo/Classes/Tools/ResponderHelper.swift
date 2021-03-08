//
//  ResponderHelper.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/3.
//

import UIKit

class ResponderHelper {
    static func topViewController(for responder: UIResponder) -> UIViewController {
        var topResponder: UIResponder? = responder
        while topResponder != nil && !(topResponder is UIViewController) {
            topResponder = topResponder?.next
        }

        if topResponder == nil {
            topResponder = UIApplication.shared.delegate?.window??.rootViewController
        }

        return topResponder as! UIViewController
    }
}
