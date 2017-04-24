//
//  String++.swift
//  SiFUtilities
//
//  Created by FOLY on 1/11/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation

public extension String {
    public static func random(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    public var htmlToAttributedString: NSAttributedString? {
        
        guard let data = data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return try? NSAttributedString(data: data,
                                       options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue)],
                                       documentAttributes: nil)
    }
    
    public var htmlToString: String? {
        
        guard let data = data(using: String.Encoding.utf8) else {
            return nil
        }
        
        var result: String?
        result = try? NSAttributedString(data: data,
                                         options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue)],
                                         documentAttributes: nil).string
        return result
    }
    
    public func containOneAtLeastRegex(separatedBy: String? = nil) -> String {
        
        let searchTags = separatedBy == nil ? [self] : self.components(separatedBy: separatedBy!)
        var regex = ".*("
        for tag in searchTags {
            regex += tag
            if tag != searchTags.last {
                regex += "|"
            }
        }
        regex += ").*"
        
        return regex
    }
    
    func toDate(format: String? = nil) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let internalFormat = format != nil ? format : "dd-MM-yyyy"
        dateFormatter.dateFormat = internalFormat
        
        return dateFormatter.date(from: self)
    }
    
    
    public func toDate(format: String? = "dd-MM-yyyy", timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        let internalFormat = format
        dateFormatter.dateFormat = internalFormat
        
        return dateFormatter.date(from: self)
    }
}
