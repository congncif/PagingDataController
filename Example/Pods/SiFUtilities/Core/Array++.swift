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
        if let index = firstIndex(of: item) {
            self.remove(at: index)
        }
    }

    public func array(removing item: Element) -> [Element] {
        var result = self
        result.remove(item)
        return result
    }

    public mutating func shuffle() {
        for _ in 0..<self.count {
            sort { _, _ in arc4random() < arc4random() }
        }
    }

    public mutating func replace(_ item: Element) {
        if let index = firstIndex(of: item) {
            self[index] = item
        }
    }
}

extension Array where Element: Hashable {
    public func after(item: Element) -> Element? {
        if let index = self.firstIndex(of: item), index + 1 < self.count {
            return self[index + 1]
        }
        return nil
    }
}

extension Array {
    public func chunk(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map { (startIndex) -> [Element] in
            let endIndex = (startIndex.advanced(by: chunkSize) > self.count) ? self.count - startIndex : chunkSize
            return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
        }
    }
}

infix operator &
public func & <T: Equatable>(lhs: [T], rhs: [T]) -> [T] {
    return lhs.filter { rhs.contains($0) }
}

extension Collection {
    public subscript(safe index: Index) -> Element? {
        return self.safeElement(at: index)
    }

    public func safeElement(at index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
