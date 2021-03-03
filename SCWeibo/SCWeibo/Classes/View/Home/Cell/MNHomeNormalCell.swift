//
//  MNHomeNormalCell.swift
//  SCWeibo
//
//  Created by scwang on 2020/3/24.
//

import UIKit

class MNHomeNormalCell: MNHomeBaseCell {
    override func setupSubviews() {
        super.setupSubviews()
        contentPictureView = MNStatusPictureView(parentView: self,
                                                 topView: contentLabel,
                                                 bottomView: bottomView)
    }
}


