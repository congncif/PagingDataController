//
//  Endpoint.swift
//  SiFUtilities
//
//  Created by FOLY on 3/26/18.
//

import Foundation

public protocol EndpointProtocol: CustomStringConvertible {
    static var base: String { get } // base path contains scheme, host, port
    static var root: String { get } // root path for a group of resource
}

func PathHelper(format: String) -> (_ params: CVaListPointer) -> String {
    return { (params: CVaListPointer) in
        NSString(format: format, arguments: params) as String
    }
}

extension EndpointProtocol {
    // Need explicitly implementing
//    public static var base: String {
//        return String()
//    }
//
//    public static var root: String {
//        return String(describing: self)
//    }

    public func path(base: String = String(), _ arguments: CVarArg...) -> String {
        let basePath = base.isEmpty ? Self.base : base
        let purePath = basePath +/ (Self.root.isEmpty ? description : Self.root +/ description)
        if arguments.count > 0 {
            let helper = PathHelper(format: purePath)
            return withVaList(arguments) { helper($0) }
        } else {
            return purePath
        }
    }

    public static func path(base: String = String(), _ arguments: CVarArg...) -> String {
        let basePath = base.isEmpty ? Self.base : base
        let purePath = basePath +/ Self.root
        if arguments.count > 0 {
            let helper = PathHelper(format: purePath)
            return withVaList(arguments) { helper($0) }
        } else {
            return purePath
        }
    }

    public func path(base: String = String()) -> String {
        let basePath = base.isEmpty ? Self.base : base
        let purePath = basePath +/ (Self.root.isEmpty ? description : Self.root +/ description)
        return purePath
    }

    public static func path(base: String = String()) -> String {
        let basePath = base.isEmpty ? Self.base : base
        let purePath = basePath +/ Self.root
        return purePath
    }
}

infix operator +/: AdditionPrecedence
public func +/(lhs: String, rhs: String) -> String {
    return lhs + "/" + rhs
}

extension RawRepresentable where Self.RawValue == String {
    public var description: String {
        return rawValue
    }
}
