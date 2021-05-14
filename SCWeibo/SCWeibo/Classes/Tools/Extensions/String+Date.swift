//
//  String+Date.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/19.
//

import Foundation

private let dateFormatter = DateFormatter()

extension String {
    var semanticDateDescription: String? {
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }

        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            let delta = -Int(date.timeIntervalSinceNow)
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            return "\(delta / 3600) 小时前"
        }

        var fmt = " HH:mm"
        if calendar.isDateInYesterday(date) {
            fmt = "昨天" + fmt
        } else {
            fmt = "MM-dd" + fmt
            let year = calendar.component(.year, from: date)
            let thisYear = calendar.component(.year, from: Date())
            if year != thisYear {
                fmt = "yyyy-" + fmt
            }
        }

        dateFormatter.dateFormat = fmt
        return dateFormatter.string(from: date)
    }
}
