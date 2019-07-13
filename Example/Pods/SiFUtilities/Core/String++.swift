//
//  String++.swift
//  SiFUtilities
//
//  Created by FOLY on 1/11/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation

extension String {
    public static func random(length: Int = 16) -> String {
        let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = String()
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    public static func uuid() -> String {
        return UUID().uuidString
    }
    
    public static func uniqueIdentifier() -> String {
        return self.uuid().lowercased()
    }
    
    public func toDate(format: String? = "dd/MM/yyyy", timeZone: TimeZone? = TimeZone(secondsFromGMT: 0)) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        let internalFormat = format
        dateFormatter.dateFormat = internalFormat
        
        return dateFormatter.date(from: self)
    }
    
    public var trimmedWhiteSpaces: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func removingCharacters(_ characters: CharacterSet) -> String {
        return components(separatedBy: characters).joined()
    }
    
    public var removedWhiteSpaces: String {
        return self.removingCharacters(.whitespacesAndNewlines)
    }
    
    public var words: [String] {
        return components(separatedBy: .punctuationCharacters)
            .joined()
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
    }
}

extension String {
    public func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    public func lowercasingFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    public mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    public mutating func lowercaseFirstLetter() {
        self = self.lowercasingFirstLetter()
    }
    
    public func snakeCased() -> String {
        let pattern = "([a-z0-9])([A-Z])"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.count)
        return regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased() ?? self
    }
    
    public func camelCased(separator: String = "_", skipFirstLetter: Bool = true) -> String {
        let components = self.components(separatedBy: separator)
        var newComponents: [String] = []
        
        for (idx, word) in components.enumerated() {
            if idx == 0, skipFirstLetter {
                newComponents.append(word.lowercased())
            } else {
                newComponents.append(word.lowercased().capitalizingFirstLetter())
            }
        }
        
        if newComponents.count <= 1 {
            return self
        }
        
        return newComponents.joined()
    }
}
