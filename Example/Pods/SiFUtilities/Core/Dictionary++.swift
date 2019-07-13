//
//  Dictionary++.swift
//  Pods
//
//  Created by FOLY on 9/13/17.
//
//

import Foundation

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (key, value) in dict {
            updateValue(value, forKey: key)
        }
    }
}
