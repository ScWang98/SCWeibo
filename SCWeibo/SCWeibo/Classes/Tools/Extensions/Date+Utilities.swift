//
//  Date+Utilities.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/21.
//

import Foundation

extension Date: UtilitiesWrapperableValue {}

private let dateFormat = "yyyy-MM-dd HH:mm:ss Z"

extension UtilitiesWrapper where Base == Date {
    public var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: base)
    }

    public static func date(from string: String) -> Base? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: string)
    }
}
