//
//  CommonError.swift
//  SiFUtilities
//
//  Created by FOLY on 2/4/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation

public struct CommonError {
    public var title: String?
    public var message: String?
    public var suggestion: String?
    public var help: String?
}

extension CommonError {
    public init(title: String? = nil, message: String?) {
        self.title = title
        self.message = message
    }
}

extension CommonError: LocalizedError {
    public var errorDescription: String? {
        return title
    }

    public var failureReason: String? {
        return message
    }

    public var recoverySuggestion: String? {
        return suggestion
    }

    public var helpAnchor: String? {
        return help
    }
}
