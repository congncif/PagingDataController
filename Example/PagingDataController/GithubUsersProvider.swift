//
//  GithubUsersViewControllerProvider.swift
//  PagingDataController
//
//  Created by FOLY on 8/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import PagingDataController
import Alamofire

class GithubUsersProvider: PagingProviderProtocol {
    
    var pageSize: Int = 20
    
    public func loadData(_ parameters: AnyObject?, page: Int, done: (([Dictionary<String, AnyObject>]) -> ())?, finish: ((Error?) -> ())?) {
        let apiPath = "https://api.github.com/search/users?q=apple&page=\(page+1)&per_page=\(pageSize)"
        
        Alamofire.request(apiPath, method: .get).responseJSON { (response) in
            
            defer {finish?(nil)}
            
            let data = response.result.value
            guard data != nil else { return }
            let result = data as! [String: AnyObject]
            done?(result["items"] as! [[String: AnyObject]])
            
        }
    }
}
