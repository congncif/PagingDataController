//
//  Debouncer.swift
//
//
//  Created by NGUYEN CHI CONG on 3/2/17.
//  Copyright © 2017 [iF] Solution Co., Ltd. All rights reserved.
//

import Foundation

public class Debouncer: NSObject {
    public private(set) var callback: (() -> ())
    public private(set) var delay: Double
    public private(set) weak var timer: Timer?
    
    public init(delay: Double, callback: @escaping (() -> ())) {
        self.delay = delay
        self.callback = callback
    }
    
    public func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    @objc public func fireNow() {
        self.callback()
    }
}
