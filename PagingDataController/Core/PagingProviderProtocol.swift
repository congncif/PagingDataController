//
//  PagingProviderProtocol.swift
//  PagingDataController
//
//  Created by Nguyen Chi Cong on 5/27/16.
//  Copyright © 2016 FOLY. All rights reserved.
//

import Foundation

/**
 *  Protocol for data provider. Implement this to fetch data
 *  Specify dataModel & pageSize
 *  Implement loadData method
 */

public protocol PagingProviderProtocol {
    associatedtype Paramter
    associatedtype Model
    var pageSize: Int { get }
    func loadData(parameters: Paramter?, page: Int, completion: @escaping ([Model], Error?) -> Void)
}

extension PagingProviderProtocol {
    public var pageSize: Int {
        return PageDataSettings().pageSize
    }
    
    public func convertDataCollection<M>(objects: [M]?, converter: (M) throws -> Self.Model) -> (result: [Self.Model], error: Error?) {
        var results: [Self.Model] = []
        guard let objects = objects else {
            return (results, nil)
        }
        do {
            results = try objects.map(converter)
        } catch {
            let message = "*** Exception in covert data from \(M.self) to \(Self.Model.self)***"
            print(message)
            
            let error = NSError(domain: "localhost", code: 1810, userInfo: [NSLocalizedDescriptionKey: message])
            
            return ([], error)
        }
        return (results, nil)
    }
    
    public func processResult<T>(result: [T]?, error: Error?, completion: (([T], Error?) -> Void)?) {
        var newResult: [T]
        defer {
            completion?(newResult, error)
        }
        guard let result = result else {
            newResult = []
            return
        }
        newResult = result
    }
}
