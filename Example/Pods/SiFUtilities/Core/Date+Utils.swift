//
//  Date+Utils.swift
//  SiFUtilities
//
//  Created by FOLY on 2/4/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation

extension Date {
    public func age() -> Int? {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year
    }
}

extension Date {
    public func toString(format: String? = "dd/MM/yyyy", timeZone: TimeZone? = TimeZone(secondsFromGMT: 0)) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        let internalFormat = format
        dateFormatter.dateFormat = internalFormat
        
        return dateFormatter.string(from: self)
    }
    
    public var localDateFromGMT: Date {
        let timezone = TimeZone.current
        let seconds = timezone.secondsFromGMT(for: self)
        return Date(timeInterval: TimeInterval(seconds), since: self)
    }
    
    public var gmtDateFromLocal: Date {
        let timezone = TimeZone.current
        let seconds = timezone.secondsFromGMT(for: self)
        return Date(timeInterval: TimeInterval(-seconds), since: self)
    }
}
