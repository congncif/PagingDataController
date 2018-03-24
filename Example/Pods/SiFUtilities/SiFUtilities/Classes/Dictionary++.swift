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
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
