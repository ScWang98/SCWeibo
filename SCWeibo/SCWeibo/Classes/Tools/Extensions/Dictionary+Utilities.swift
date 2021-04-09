//
//  Dictionary+Utilities.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/18.
//

import Foundation

extension Dictionary: UtilitiesWrapperableValue {
}

protocol DictionaryUtilities {
    associatedtype Key: Hashable
    associatedtype Value
}

extension Dictionary: DictionaryUtilities {
    typealias Key = Key
    typealias Value = Value
}

extension UtilitiesWrapper where Base: DictionaryUtilities {
    func string(for key: Base.Key) -> String? {
        guard let dictionary = base as? [Base.Key: Base.Value],
              let value = dictionary[key] else {
            return nil
        }

        if let string = value as? String {
            return string
        }
        if let number = value as? NSNumber {
            return number.stringValue
        }
        return nil
    }
    
    func bool(for key: Base.Key, defaultValue: Bool = false) -> Bool {
        guard let dictionary = base as? [Base.Key: Base.Value],
              let value = dictionary[key] else {
            return defaultValue
        }

        if let boolValue = value as? Bool {
            return boolValue
        }
        if let number = value as? NSNumber {
            return number.boolValue
        }
        return defaultValue
    }

    func int(for key: Base.Key, defaultValue: Int = 0) -> Int {
        guard let dictionary = base as? [Base.Key: Base.Value],
              let value = dictionary[key] else {
            return defaultValue
        }

        if let intValue = value as? Int {
            return intValue
        }
        if let number = value as? NSNumber {
            return number.intValue
        }
        return defaultValue
    }

    func array<T>(for key: Base.Key) -> Array<T>? {
        guard let dictionary = base as? [Base.Key: Base.Value],
              let value = dictionary[key] else {
            return nil
        }

        if let array = value as? Array<T> {
            return array
        }
        return nil
    }

    func dictionary<K, V>(for key: Base.Key) -> Dictionary<K, V>? {
        guard let dictionary = base as? [Base.Key: Base.Value],
              let value = dictionary[key] else {
            return nil
        }

        if let dictionary = value as? Dictionary<K, V> {
            return dictionary
        }
        return nil
    }
}
