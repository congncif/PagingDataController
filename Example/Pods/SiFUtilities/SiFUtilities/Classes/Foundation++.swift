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

public extension NSObject{
    public class var className: String{
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    public var className: String{
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
                let property = properties?[Int(i)]
                
                // retrieve the property name by calling property_getName function
                let cname = property_getName(property)
                
                // covert the c string into a Swift string
                let name = String(cString: cname!)
                results.append(name)
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

//MARK: - Sequence
//////////////////////////////////////////////////////////////////////////////////////

public extension Array {
    
    public mutating func shuffle() {
        for _ in 0..<self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

public extension Sequence {
    
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    
    func categorise<U : Hashable>(_ keyFunc: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}

//////////////////////////////////////////////////////////////////////////////////////

public extension Date {
    public func toString(format: String? = "dd-MM-yyyy", timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        let internalFormat = format
        dateFormatter.dateFormat = internalFormat
        
        return dateFormatter.string(from: self)
    }
}

public extension URL {
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
