//
//  ExtensionUtilities.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/1.
//

public struct UtilitiesWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol UtilitiesWrapperable: AnyObject {
}

public protocol UtilitiesWrapperableValue {
}

extension UtilitiesWrapperable {
    public var sc: UtilitiesWrapper<Self> {
        return UtilitiesWrapper(self)
    }

    public static var sc: UtilitiesWrapper<Self>.Type {
        return UtilitiesWrapper.self
    }
}

extension UtilitiesWrapperableValue {
    public var sc: UtilitiesWrapper<Self> {
        return UtilitiesWrapper(self)
    }

    public static var sc: UtilitiesWrapper<Self>.Type {
        return UtilitiesWrapper.self
    }
}
