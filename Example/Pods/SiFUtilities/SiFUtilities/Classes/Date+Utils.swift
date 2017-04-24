//
//  Date+Utils.swift
//  Meeting Up
//
//  Created by FOLY on 2/4/17.
//  Copyright © 2017 Julian Heissl. All rights reserved.
//

import Foundation

public extension Date {
    public var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}
