//
//  Extensions.swift
//  Pods
//
//  Created by FOLY on 5/29/16.
//
//

import Foundation

public func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

public func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


//MARK: - NSObjects

extension NSObject {
    open class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    open var className: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}


public protocol PropertyNames: class {
    var propertyNames: [String] {get}
}

public extension PropertyNames {
    public var propertyNames: [String] {
        
        if self is NSObject {
            var results: Array<String> = []
            
            // retrieve the properties via the class_copyPropertyList function
            var count: UInt32 = 0
            let myClass: AnyClass = Self.self //self.classForCoder
            let properties = class_copyPropertyList(myClass, &count)
            
            // iterate each objc_property_t struct
            for i: UInt32 in 0 ..< count {
                if let property = properties?[Int(i)] {
                    // retrieve the property name by calling property_getName function
                    // covert the c string into a Swift string
                    #if swift(>=4.0)
                        let cname = property_getName(property)
                        let name = String(cString: cname)
                        results.append(name)
                    #else
                        if let cname = property_getName(property) {
                            let name = String(cString: cname)
                            results.append(name)
                        }
                    #endif
                }
            }
            
            // release objc_property_t structs
            free(properties)
            
            return results
        }else {
            return Mirror(reflecting: self).children.flatMap { $0.label }
        }
    }
}

extension NSObject: PropertyNames {}


extension URL {
    public var keyValueParameters: Dictionary<String, String>? {
        var results = [String:String]()
        let keyValues = self.query?.components(separatedBy: "&")
        if keyValues?.count > 0 {
            for pair in keyValues! {
                let kv = pair.components(separatedBy: "=")
                if kv.count > 1 {
                    results.updateValue(kv[1], forKey: kv[0])
                }
            }
        }
        return results
    }
}

// MARK: - Push
//////////////////////////////////////////////////////////////////////////////////////

public extension Data {
    public var deviceToken: String {
        let characterSet: CharacterSet = CharacterSet( charactersIn: "<>" )
        
        let deviceTokenString: String = ( self.description as NSString )
            .trimmingCharacters( in: characterSet )
            .replacingOccurrences( of: " ", with: "" ) as String
        
        return deviceTokenString
    }
}
