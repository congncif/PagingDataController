//
//  Optional++.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 3/30/19.
//

import Foundation

extension Optional where Wrapped == String {
    public var isNoValue: Bool {
        switch self {
        case .none:
            return true
        case .some(let value):
            return value.isEmpty
        }
    }

    public func unwrapped(_ default: String = String()) -> String {
        return self ?? `default`
    }
}

extension Optional {
    public func unwrapped(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
}
