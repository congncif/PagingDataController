//
//  KeyValueProtocol.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 11/9/16.
//  Copyright © 2016 NGUYEN CHI CONG. All rights reserved.
//

import Foundation

public protocol KeyValueProtocol {
    var mapKeys: [String: String] {get}
    var ignoreKeys: [String] {get}
}

extension KeyValueProtocol {
    public var mapKeys: [String: String] {
        return [:]
    }
    
    public var ignoreKeys: [String] {
        return []
    }
    
    public func mapKey(for key: String) -> String {
        var newKey = key
        if let mapKey = mapKeys[key] {
            newKey = mapKey
        }
        return newKey
    }
}

func wrap(any: Any) -> Any? {
    let mi = Mirror(reflecting: any)
    if let style = mi.displayStyle {
        if style != .optional {
            return any
        }
        if mi.children.count == 0 { return nil }
        let (_, some) = mi.children.first!
        return some
    }
    return any
}

public extension KeyValueProtocol {
    public var dictionary: [String: Any] {
        var dict = [String: Any]()
        let otherSelf = Mirror(reflecting: self)
        
        for child in otherSelf.children {
            if let key = child.label {
                if ignoreKeys.contains(key) {
                    continue
                }
                let newKey = mapKey(for: key)
                dict[newKey] = parse(value: child.value)
            }
        }
        
        var mirror: Mirror = otherSelf
        
        while let superMirror = mirror.superclassMirror {
            for child in superMirror.children {
                if let key = child.label {
                    if ignoreKeys.contains(key) {
                        continue
                    }
                    let newKey = mapKey(for: key)
                    dict[newKey] = parse(value: child.value)
                }
            }
            mirror = superMirror
        }
        
        return dict
    }
    
    func parse(value: Any) -> Any? {
        
        let wrappedValue = wrap(any: value)
        
        if let object = wrappedValue as? KeyValueProtocol {
            return object.dictionary
        }
        else if let values = wrappedValue as? [KeyValueProtocol] {
            return values.map({ (item) -> [String: Any] in
                return item.dictionary
            })
        }
        else {
            return wrappedValue
        }
    }
    
    public var JSONString: String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary,
                                                      options: .prettyPrinted)
            return String(data: jsonData, encoding: String.Encoding.utf8)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public var keys: [String] {
        var results = [String]()
        let otherSelf = Mirror(reflecting: self)
        
        for child in otherSelf.children {
            if let key = child.label {
                let newKey = mapKey(for: key)
                results.append(newKey)
            }
        }
        
        var mirror: Mirror = otherSelf
        
        while let superMirror = mirror.superclassMirror {
            for child in superMirror.children {
                if let key = child.label {
                    let newKey = mapKey(for: key)
                    results.append(newKey)
                }
            }
            mirror = superMirror
        }
        
        return results
    }
}

open class KeyValueObject: NSObject, KeyValueProtocol {
    public init(dictionary: [String: Any]) {
        super.init()
        self.setValuesForKeys(dictionary)
    }
    
    public override init() {
        super.init()
    }
}
