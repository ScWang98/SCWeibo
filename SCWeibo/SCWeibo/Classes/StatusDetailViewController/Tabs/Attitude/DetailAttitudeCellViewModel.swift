//
//  DetailAttitudeCellViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Foundation

class DetailAttitudeCellViewModel {
    var model: AttitudeModel
    var avatarUrl: String?
    var screenName: String?

    init(with model: AttitudeModel) {
        self.model = model
        parseProperties()
    }
}

private extension DetailAttitudeCellViewModel {
    func parseProperties() {
        avatarUrl = model.user?.avatar
        screenName = model.user?.screenName
    }
}
