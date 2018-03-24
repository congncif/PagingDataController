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
    
    /**
     * Call this func in backgound to avoid blocking UI
     * Eg:
     * DispatchQueue.global().async {
     *    let v = keeper.syncValue
     *    ...
     * }
     */
    open var syncValue: Value? {
        var val = value
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue
            .global(qos: .background)
            .asyncAfter(deadline: DispatchTime.now() + delay, execute: {
                [weak self] in
                guard let this = self else {
                    semaphore.signal()
                    return
                }
                this.getValueAsync({ newValue in
                    val = newValue
                    semaphore.signal()
                })
            })
        _ = semaphore.wait(timeout: timeout)
        return val
    }
}
