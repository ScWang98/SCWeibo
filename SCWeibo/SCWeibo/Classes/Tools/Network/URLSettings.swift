//
//  URLSettings.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/6.
//

import Foundation

class URLSettings {
    private static var baseURL: String {
        return "https://api.weibo.com/2/"
    }

    static var homeStatusesURL: String {
        return baseURL + "statuses/home_timeline.json"
    }
}
