//
//  Decodable+Convenience.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/6.
//

import Foundation

extension Decodable {
    public static var sc: UtilitiesWrapper<Self>.Type {
        return UtilitiesWrapper.self
    }
}

extension UtilitiesWrapper where Base: Decodable {
    public static func decode(_ param: Dictionary<AnyHashable, Any>) -> Base? {
        guard let data = self.getJsonData(with: param),
              let model = try? JSONDecoder().decode(Base.self, from: data) else {
            return nil
        }
        return model
    }

    public static func decode(_ param: Array<Dictionary<AnyHashable, Any>>) -> [Base]? {
        guard let data = self.getJsonData(with: param),
              let models = try? JSONDecoder().decode([Base].self, from: data) else {
            return nil
        }
        return models
    }

    private static func getJsonData(with param: Any) -> Data? {
        guard JSONSerialization.isValidJSONObject(param),
              let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
}
