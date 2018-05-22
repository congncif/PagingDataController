//
//  PagingDataViewController.swift
//  PagingDataController
//
//  Created by Nguyen Chi Cong on 5/27/16.
//  Copyright © 2016 FOLY. All rights reserved.
//

import UIKit

public protocol PagingControllerProtocol: AnyObject {

    associatedtype PagingProvider: PagingProviderProtocol
    var provider: PagingProvider { get }
    var dataSource: PageDataSource<PagingProvider.Model> { get set }

    func loadDataPage(_ page: Int, start: (() -> Void)?, done: (() -> Void)?)
    func nextPage() -> Int
    func parametersForPage(_ page: Int) -> PagingProvider.Paramter?
    func errorWarningForPage(_ page: Int, error: Error)
}

private var sourceKey: UInt8 = 0
public extension PagingControllerProtocol {

    public var dataSource: PageDataSource<PagingProvider.Model> {
        get {
            return self.associatedObject(self, key: &sourceKey) {
                let ds = PageDataSource<PagingProvider.Model>(pageSize: self.provider.pageSize)
                return ds

            } // Set the initial value of the var
        }
        set { self.associateObject(self, key: &sourceKey, value: newValue) }
    }

    //////////////////////////////////////////////////////////////////////////////////////

    public func loadDataPage(_ page: Int, start: (() -> Void)? = nil, done: (() -> Void)? = nil) {
        start?()

        let paramters: PagingProvider.Paramter? = parametersForPage(page)
        provider.loadData(parameters: paramters, page: page, completion: { [weak self] objects, error in

            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async { [weak self] in
                if page == 0 { self?.dataSource.reset() }
                let matches = objects
                let pageData = PageData(index: page, data: matches)
                self?.dataSource.extendDataSource(pageData)

                DispatchQueue.main.async { [weak self] in
                    done?()
                    guard error != nil else { return }
                    self?.errorWarningForPage(page, error: error!)
                }
            }
        })
    }

    public func nextPage() -> Int {
        let nextPage = self.dataSource.currentPage + 1
        return nextPage
    }

    public func parametersForPage(_ page: Int) -> PagingProvider.Paramter? {
        return nil
    }

    public func errorWarningForPage(_ page: Int, error: Error) {
        print("**** Error: \(error.localizedDescription) *****")
    }

    //////////////////////////////////////////////////////////////////////////////////////

    public func loadFirstPageWithCompletion(_ done: (() -> Void)? = nil) {
        loadDataPage(0, start: nil, done: done)
    }
    public func loadNextPageWithCompletion(_ done: (() -> Void)? = nil) {
        loadDataPage(nextPage(), start: nil, done: done)
    }

    public func pageObjectAtIndex(_ index: Int) -> PagingProvider.Model {
        return self.dataSource.allObjects[index]
    }

    // MARK: - ObjC runtime
    //////////////////////////////////////////////////////////////////////////////////////

    fileprivate func associatedObject<ValueType: AnyObject>(
        _ base: AnyObject,
        key: UnsafePointer<UInt8>,
        initialiser: () -> ValueType)
        -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
    }

    fileprivate func associateObject<ValueType: AnyObject>(
        _ base: AnyObject,
        key: UnsafePointer<UInt8>,
        value: ValueType) {
        objc_setAssociatedObject(base, key, value,
                                 .OBJC_ASSOCIATION_RETAIN)
    }

}
