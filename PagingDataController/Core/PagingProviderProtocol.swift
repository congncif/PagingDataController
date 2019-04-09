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
