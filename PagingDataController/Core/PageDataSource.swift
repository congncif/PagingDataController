//
//  PageDataSource.swift
//  PagingDataController
//
//  Created by Nguyen Chi Cong on 5/16/16.
//  Copyright © 2016 Nguyen Chi Cong. All rights reserved.
//

import Foundation

public protocol PageDataSourceDelegate: class {
    func pageDataSourceDidChange(hasNextPage: Bool, nextPageIndicatorShouldChange shouldChange: Bool)
}

open class PageData<T> {
    open var pageIndex: Int
    open var pageData: [T]
    
    public init(index pageIndex: Int, data pageData: [T]) {
        self.pageIndex = pageIndex
        self.pageData = pageData
    }
}

open class PageDataSource<T> {
    private let delegateProxy = PageDataSourceDelegateProxy()
    
    public var hasMore: Bool = false
    public var pageSize: Int
    
    public var allObjects: [T] {
        return getAllObjects()
    }
    
    public var data: [PageData<T>] = []
    
    public var currentPage: Int {
        let page = data.last
        guard page != nil else { return -1 }
        return page!.pageIndex
    }
    
    //    private(set) var pages: [T]
    
    public init(pageSize: Int) {
        self.pageSize = pageSize
    }
    
    public init() {
        pageSize = 36
    }
    
    public var delegate: PageDataSourceDelegate? {
        set {
            if let value = newValue {
                delegateProxy.removeAllObservers()
                delegateProxy.addObserver(value)
            } else {
                delegateProxy.removeAllObservers()
            }
        }
        
        get {
            return delegateProxy
        }
    }
    
    public func addDelegate(_ delegate: PageDataSourceDelegate?) {
        delegateProxy.addObserver(delegate)
    }
    
    public func removeDelegate(_ delegate: PageDataSourceDelegate?) {
        delegateProxy.removeObserver(delegate)
    }
    
    open func extendDataSource(_ page: PageData<T>) {
        if !pageIsExists(page.pageIndex) {
            data.append(page)
            pageDataSourceDidExtend(pageData: page.pageData, at: page.pageIndex)
            
            var shouldChange = false
            if page.pageData.count < pageSize {
                let newFlag = false
                if hasMore != newFlag {
                    hasMore = newFlag
                    shouldChange = true
                }
            } else {
                let newFlag = true
                if hasMore != newFlag {
                    hasMore = newFlag
                    shouldChange = true
                }
            }
            
            notifyToDelegate(nextPageIndicatorShouldChange: shouldChange)
        } else {
            print("Page \(page.pageIndex) is exists")
        }
    }
    
    open func reset() {
        data.removeAll()
        pageDataSourceDidReset()
        
        //        let changed = (hasMore == false) // at last page
        hasMore = false
        notifyToDelegate(nextPageIndicatorShouldChange: true)
    }
    
    open func pageIsExists(_ index: Int) -> Bool {
        let pages = data.filter { (pageData) -> Bool in
            pageData.pageIndex == index
        }
        
        return !pages.isEmpty
    }
    
    open func pageDataSourceDidExtend(pageData: [T], at page: Int) {}
    open func pageDataSourceDidReset() {}
}

extension PageDataSource {
    private func notifyToDelegate(nextPageIndicatorShouldChange: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.pageDataSourceDidChange(hasNextPage: self.hasMore, nextPageIndicatorShouldChange: nextPageIndicatorShouldChange)
        }
    }
    
    private func getAllObjects() -> [T] {
        var source: [T] = [T]()
        for page in data {
            source += page.pageData
        }
        return source
    }
}
