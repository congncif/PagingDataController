//
//  PageDataSourceDelegateProxy.swift
//  PagingDataControllerExtension
//
//  Created by NGUYEN CHI CONG on 4/7/19.
//

import Foundation
import SiFUtilities

private struct PageDataSourceDelegation: Equatable {
    var identifier: String
    weak var delegate: PageDataSourceDelegate?
    
    init(delegate: PageDataSourceDelegate?) {
        identifier = String(describing: delegate)
        self.delegate = delegate
    }
    
    static func == (lhs: PageDataSourceDelegation, rhs: PageDataSourceDelegation) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

public final class PageDataSourceDelegateProxy: PageDataSourceDelegate {
    private var observers: [PageDataSourceDelegation] = []
    
    public init(delegates: PageDataSourceDelegate...) {
        let observers = delegates.map { PageDataSourceDelegation(delegate: $0) }
        self.observers = observers
    }
    
    public func addObserver(_ observer: PageDataSourceDelegate?) {
        let newObserver = PageDataSourceDelegation(delegate: observer)
        guard !observers.contains(newObserver) else { return }
        observers.append(newObserver)
    }
    
    public func removeObserver(_ observer: PageDataSourceDelegate?) {
        let newObserver = PageDataSourceDelegation(delegate: observer)
        guard observers.contains(newObserver) else { return }
        observers.remove(newObserver)
    }
    
    public func removeAllObservers() {
        observers.removeAll()
    }
    
    public var delegates: [PageDataSourceDelegate] {
        return observers.compactMap { $0.delegate }
    }
    
    public func pageDataSourceDidChange(hasNextPage: Bool, nextPageIndicatorShouldChange shouldChange: Bool) {
        delegates.forEach { delegate in
            delegate.pageDataSourceDidChange(hasNextPage: hasNextPage, nextPageIndicatorShouldChange: shouldChange)
        }
    }
}
