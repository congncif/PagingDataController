//
//  CommonError.swift
//  SiFUtilities
//
//  Created by FOLY on 2/4/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation

open class CommonError: Error {
    open var title: String?
    open var message: String?
    
    public init(title: String? = nil, message: String? = nil) {
        self.title = title
        self.message = message
    }
    
    open var localizedDescription: String {
        return self.message ?? "Unkown error"
    }
}
