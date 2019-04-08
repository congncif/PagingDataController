//
//  PagingDataViewController.swift
//  PagingDataController
//
//  Created by Nguyen Chi Cong on 5/27/16.
//  Copyright © 2016 FOLY. All rights reserved.
//

import UIKit

public protocol PagingControllerDelegate: AnyObject {
    func pagingControllerDidSuccessLoad()
    func pagingControllerDidFailLoadWithError(error: Error)
}

public protocol PagingControllerProtocol: AnyObject {
    associatedtype PagingProvider: PagingProviderProtocol

    var provider: PagingProvider { get }
    var dataSource: PageDataSource<PagingProvider.Model> { get set }
    var delegate: PagingControllerDelegate? { get }

    func loadDataPage(_ page: Int, start: (() -> Void)?, done: (() -> Void)?)
    func nextPage() -> Int
    func parametersForPage(_ page: Int) -> PagingProvider.Paramter?
}

private var dataSourceKey: UInt8 = 0
private var delegateKey: UInt8 = 1

extension PagingControllerProtocol {
    public var dataSource: PageDataSource<PagingProvider.Model> {
        get {
            return self._associatedObject(self, key: &dataSourceKey) {
                let source = PageDataSource<PagingProvider.Model>(pageSize: self.provider.pageSize)
                return source
            }
        }
        set { self._associateObject(self, key: &dataSourceKey, value: newValue) }
    }

    public weak var delegate: PagingControllerDelegate? {
        get {
            return self._getAssociatedObject(key: &delegateKey)
        }
        set {
            self._setAssociatedObject(key: &delegateKey, value: newValue, policy: .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    public func loadDataPage(_ page: Int, start: (() -> Void)? = nil, done: (() -> Void)? = nil) {
        start?()

        let paramters: PagingProvider.Paramter? = parametersForPage(page)
        provider.loadData(parameters: paramters, page: page, completion: { [weak self] objects, error in

            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [weak self] in
                if page == 0 { self?.dataSource.reset() }
                let matches = objects
                let pageData = PageData(index: page, data: matches)
                self?.dataSource.extendDataSource(pageData)
                DispatchQueue.main.async { [weak self] in
                    if let error = error {
                        self?.delegate?.pagingControllerDidFailLoadWithError(error: error)
                    } else {
                        self?.delegate?.pagingControllerDidSuccessLoad()
                    }
                    done?()
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

    public func loadFirstPageWithCompletion(_ done: (() -> Void)? = nil) {
        self.loadDataPage(0, start: nil, done: done)
    }

    public func loadNextPageWithCompletion(_ done: (() -> Void)? = nil) {
        self.loadDataPage(self.nextPage(), start: nil, done: done)
    }

    public func pageObjectAtIndex(_ index: Int) -> PagingProvider.Model {
        return self.dataSource.allObjects[index]
    }

    // MARK: - ObjC runtime

    private func _associatedObject<ValueType: AnyObject>(
        _ base: AnyObject,
        key: UnsafePointer<UInt8>,
        policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN,
        initialiser: () -> ValueType)
        -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated, policy)
        return associated
    }

    private func _associateObject<ValueType: AnyObject>(
        _ base: AnyObject,
        key: UnsafePointer<UInt8>,
        policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN,
        value: ValueType) {
        objc_setAssociatedObject(base, key, value, policy)
    }

    private func _getAssociatedObject<T>(key: inout UInt8) -> T? {
        return objc_getAssociatedObject(self, &key) as? T
    }

    private func _setAssociatedObject<T>(key: inout UInt8,
                                         value: T?,
                                         policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, &key, value, policy)
    }
}
