//
//  Array++.swift
//  Pods
//
//  Created by FOLY on 9/13/17.
//
//

import Foundation

extension Array where Element: Equatable {
    public mutating func remove(_ item: Element) {
        if let index = index(of: item) {
            remove(at: index)
        }
    }
    
    public func array(removing item: Element) -> [Element] {
        var result = self
        result.remove(item)
        return result
    }
    
    public mutating func shuffle() {
        for _ in 0..<self.count {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
    
    public mutating func replace(_ item: Element) {
        if let index = index(of: item) {
            self[index] = item
        }
    }
}

extension Sequence {
    /// Categorises elements of self into a dictionary, with the keys given by keyFunc
    public func categorise<U : Hashable>(_ keyFunc: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = keyFunc(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}
