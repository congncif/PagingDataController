//
//  KeyValueProtocol.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 11/9/16.
//  Copyright © 2016 NGUYEN CHI CONG. All rights reserved.
//

import Foundation

public protocol KeyValueProtocol {}

public extension KeyValueProtocol {
    public var dictionary: [String: Any] {
        var dict = [String: Any]()
        let otherSelf = Mirror(reflecting: self)
        
        for child in otherSelf.children {
            if let key = child.label {
                if let value = child.value as? KeyValueProtocol {
                    dict[key] = value.dictionary
                }
                else if let values = child.value as? [KeyValueProtocol] {
                    dict[key] = values.map({ (item) -> [String: Any] in
                        return item.dictionary
                    })
                }
                else {
                    dict[key] = child.value
                }
            }
        }
        
        var mirror: Mirror = otherSelf
        
        while let superMirror = mirror.superclassMirror {
            for child in superMirror.children {
                if let key = child.label {
                    if let value = child.value as? KeyValueProtocol {
                        dict[key] = value.dictionary
                    }
                    else if let values = child.value as? [KeyValueProtocol] {
                        dict[key] = values.map({ (item) -> [String: Any] in
                            return item.dictionary
                        })
                    }
                    else {
                        dict[key] = child.value
                    }
                }
            }
            mirror = superMirror
        }
        
        return dict
    }
    
    public var JSONString: String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
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
                results.append(key)
            }
        }
        
        var mirror: Mirror = otherSelf
        
        while let superMirror = mirror.superclassMirror {
            for child in superMirror.children {
                if let key = child.label {
                    results.append(key)
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
