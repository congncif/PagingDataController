//
//  ValueKeeper.swift
//  Pods
//
//  Created by FOLY on 7/7/17.
//
//

import Foundation

open class ValueKeeper<Value> {
    private var value: Value?
    private var delay: Double
    private var timeout: DispatchTime
    private var getValueAsync: ((@escaping (Value?) -> Void) -> Void)
    
    public init(defaultValue: Value? = nil,
                delay: Double = 0,
                timeout: DispatchTime = DispatchTime.distantFuture,
                getValueAsync: @escaping ((@escaping (Value?) -> Void) -> Void)) {
        value = defaultValue
        self.delay = delay
        self.timeout = timeout
        self.getValueAsync = getValueAsync
    }
    
    open var syncValue: Value? {
        var val = value
//        let semaphore = DispatchSemaphore(value: 0)
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue
            .global()
            .asyncAfter(deadline: DispatchTime.now() + delay, execute: { [weak self] in
                guard let this = self else {
//                    semaphore.signal()
                    group.leave()
                    return
                }
                this.getValueAsync({ newValue in
                    val = newValue
//                    semaphore.signal()
                    group.leave()
                })
            })
//        _ = semaphore.wait(timeout: timeout)
        _ = group.wait(timeout: timeout)
        
        return val
    }
}
