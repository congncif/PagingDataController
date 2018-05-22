//
//  PageDataSource.swift
//  PagingDataController
//
//  Created by Nguyen Chi Cong on 5/16/16.
//  Copyright © 2016 Nguyen Chi Cong. All rights reserved.
//

import Foundation

public struct PageDataSettings {
    public var pageSize: Int = 60
    
    public init() {}
    public init(pageSize: Int) {
        self.pageSize = pageSize
    }
}

public protocol PageDataSourceDelegate: class {
    func pageDataSourceDidChanged(hasNextPage: Bool, infiniteScrollingShouldChange shouldChange: Bool)
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
    
    open weak var delegate: PageDataSourceDelegate?
    
    open var settings: PageDataSettings = PageDataSettings()
    open var hasMore: Bool = false
    open var allObjects: [T] {
        return getAllObjects()
    }
    
    public var data: [PageData<T>] = [PageData<T>]()
    open var currentPage: Int {
        let page = data.last
        guard page != nil else { return -1 }
        return page!.pageIndex
    }
    //    private(set) var pages: [T]
    
    public init() {
        settings = PageDataSettings()
    }
    
    public convenience init(pageSettings: PageDataSettings) {
        self.init()
        settings = pageSettings
    }
    
    public convenience init(pageSize: Int) {
        self.init()
        settings = PageDataSettings(pageSize: pageSize)
    }
    
    fileprivate func getAllObjects() -> [T] {
        var source: [T] = [T]()
        for page in data {
            source += page.pageData
        }
        return source
    }
    
    //////////////////////////////////////////////////////////////////////////////////////
    
    open func extendDataSource(_ page: PageData<T>) {
        
        if !pageIsExists(page.pageIndex) {
            data.append(page)
            onExtend(pageData: page.pageData, at: page.pageIndex)
            
            var changed = false
            if page.pageData.count < settings.pageSize {
                changed = (hasMore == true) // near last page
                hasMore = false
            } else {
                hasMore = true
            }
            
            delegate?.pageDataSourceDidChanged(hasNextPage: hasMore, infiniteScrollingShouldChange: changed)
        } else {
            print("Page \(page.pageIndex) is exists")
        }
    }
    
    open func reset() {
        data.removeAll()
        onReset()
        
        //        let changed = (hasMore == false) // at last page
        hasMore = false
        delegate?.pageDataSourceDidChanged(hasNextPage: hasMore, infiniteScrollingShouldChange: true)
        
    }
    
    open func pageIsExists(_ index: Int) -> Bool {
        let pages = data.filter { (pageData) -> Bool in
            return pageData.pageIndex == index
        }
        
        return pages.count > 0
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////
    open func onExtend(pageData: [T], at page: Int) {}
    
    open func onReset() {}
}
