//
//  Common.swift
//  SiFUtilities
//
//  Created by FOLY on 2/4/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation

public func LocalizedString(_ string: String, tableName: String? = nil) -> String {
    return NSLocalizedString(string, tableName: tableName, comment: string)
}
