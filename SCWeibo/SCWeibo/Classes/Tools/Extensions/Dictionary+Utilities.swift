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
    
}

extension UtilitiesWrapper where Base: DictionaryUtilities {
    
    
    func string(for key: Base.Key, defaultValue: String? = nil) -> String? {
        guard let dictionary = base as? [Base.Key: Base.Value] else {
            return defaultValue
        }
        guard let value = dictionary[key] else {
            return defaultValue
        }
        
        if let string = value as? String {
            return string
        }
        if let number = value as? NSNumber {
            return number.stringValue
        }
        return defaultValue
    }
    
    func dictionary<K, V>(for key: Base.Key, defaultValue: Dictionary<K, V>? = nil) -> Dictionary<K, V>? {
        guard let dictionary = base as? [Base.Key: Base.Value] else {
            return defaultValue
        }
        guard let value = dictionary[key] else {
            return defaultValue
        }
        
        if let dictionary = value as? Dictionary<K, V> {
            return dictionary
        }
        return defaultValue
    }
    
}
