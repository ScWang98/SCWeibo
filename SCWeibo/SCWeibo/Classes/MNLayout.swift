//
//  MNLayout.swift
//  SCWeibo
//
//  Created by miniLV on 2020/3/22.
//

import UIKit

struct MNLayout {

    static let ratio:CGFloat = UIScreen.main.bounds.width / 375.0
    static func Layout(_ number: CGFloat) -> CGFloat {
        return number * ratio
    }
}

