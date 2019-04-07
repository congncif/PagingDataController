//
//  AbstractPageProvider.swift
//  PagingDataControllerExtension
//
//  Created by NGUYEN CHI CONG on 4/7/19.
//

import Foundation

open class AbstractPageProvider<Input, Output>: PagingProviderProtocol {
    public typealias Paramter = Input
    public typealias Model = Output

    open var pageSize: Int

    public init(pageSize: Int = 60) {
        self.pageSize = pageSize
    }

    open func loadData(parameters: Input?, page: Int, completion: @escaping ([Output], Error?) -> Void) {
        fatalError("The method is not implemented by abstract class. Must override in subclass.")
    }
}

public typealias AbstractOuputPageProvider<Output> = AbstractPageProvider<Any, Output>
