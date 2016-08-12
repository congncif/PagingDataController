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

class GithubUsersViewControllerProvider: PagingProviderProtocol {

    var pageSize: Int = 20
    
    typealias Model = [String: AnyObject]
    func loadData(parameters: [String : AnyObject]?, page: Int, done: (([Model]) -> ())?, finish: ((NSError?) -> ())?) {
        
        let apiPath = "https://api.github.com/search/users?q=apple&page=\(page+1)&per_page=\(pageSize)"
        Alamofire.request(.GET, apiPath).responseJSON { (response) in
            
            defer {finish?(nil)}
            
            let data = response.result.value
            guard data != nil else { return }
            let result = data as! [String: AnyObject]
            done?(result["items"] as! [[String: AnyObject]])
            
        }
        
    }

}
