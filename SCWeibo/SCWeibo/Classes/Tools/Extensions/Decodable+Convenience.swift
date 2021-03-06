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
        let result = decode(with: param)
        if let result = result as? Base {
            return result
        }
        return nil
    }
    
    public static func decode(_ param: Array<Dictionary<AnyHashable, Any>>) -> [Base]? {
        let results = decode(with: param)
        if let results = results as? [Base] {
            return results
        }
        return nil
    }
    
    private static func decode(with param: ConvenienceDecodable) -> Any? {
        guard let data = self.getJsonData(with: param),
            let model = try? JSONDecoder().decode(Base.self, from: data) else {
            return nil
        }
        return model
    }

    private static func getJsonData(with param: Any) -> Data? {
        guard JSONSerialization.isValidJSONObject(param),
            let data = try? JSONSerialization.data(withJSONObject: param, options: []) else {
            return nil
        }
        return data
    }
}

public protocol ConvenienceDecodable {}

extension Dictionary: ConvenienceDecodable {}

extension Array: ConvenienceDecodable {}
