//
//  UIButtion+Extension.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/22.
//

import UIKit

extension UIButton {
    class func mn_textButton(title: String, fontSize: CGFloat, normalColor: UIColor, highlightedColor: UIColor, backgroundImageName: String? = nil) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(normalColor, for: .normal)
        button.setTitleColor(highlightedColor, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        if let backgroundImageName = backgroundImageName {
            button.setBackgroundImage(UIImage(named: backgroundImageName), for: .normal)
            let backgroundImageNameHL = backgroundImageName + "_highlighted"
            button.setBackgroundImage(UIImage(named: backgroundImageNameHL), for: .highlighted)
        }
        return button
    }
}
