//
//  Decodable+Convenience.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/6.
//

import Foundation

protocol ConvenienceDecodable {}

extension Decodable {
    private static func decode(_ param: ConvenienceDecodable) -> Self? {
        guard let data = self.getJsonData(with: param),
            let model = try? JSONDecoder().decode(Self.self, from: data) else {
            return nil
        }
        return model
    }

    public static func getJsonData(with param: Any) -> Data? {
        guard JSONSerialization.isValidJSONObject(param),
            let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
}

extension Dictionary: ConvenienceDecodable {}

extension Array: ConvenienceDecodable {}
