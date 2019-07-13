//
//  TimeInterval+Ex.swift
//
//
//  Created by FOLY on 4/4/18.
//  Copyright © 2018 Spinshare Co., Ltd. All rights reserved.
//

import Foundation

extension TimeInterval {
    public var milliseconds: Double {
        return self * 1000
    }
}

extension Double {
    public var dateBySeconds: Date {
        return Date(timeIntervalSince1970: self)
    }

    public var dateByMilliseconds: Date {
        return Date(timeIntervalSince1970: self / 1000)
    }
}
