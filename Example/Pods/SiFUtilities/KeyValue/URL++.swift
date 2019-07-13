//
//  URL++.swift
//  SiFUtilities
//
//  Created by FOLY on 9/22/18.
//

import Foundation

extension URL {
    public var keyValueParameters: Dictionary<String, String>? {
        guard let keyValues = self.query?.components(separatedBy: "&") else {
            return nil
        }
        var results = [String: String]()
        if keyValues.count > 0 {
            for pair in keyValues {
                let kv = pair.components(separatedBy: "=")
                if kv.count > 1 {
                    results.updateValue(kv[1], forKey: kv[0])
                }
            }
        }
        return results
    }
}
