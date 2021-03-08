//
//  UILabel+Extension.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/21.
//

import UIKit

extension UILabel{
    class func mn_label(text:String, fontSize:CGFloat, color:UIColor) -> UILabel{
        
        let label = self.init()
        label.text = text
        label.font = UIFont.systemFont(ofSize: MNLayout.Layout(fontSize))
        label.textColor = color
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }
}
