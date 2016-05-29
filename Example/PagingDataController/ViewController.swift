//
//  ViewController.swift
//  PagingDataController
//
//  Created by NGUYEN CHI CONG on 05/28/2016.
//  Copyright (c) 2016 NGUYEN CHI CONG. All rights reserved.
//

import UIKit
import PagingDataController
import SiFUtilities
import Alamofire

struct UsersProvider: PagingProviderProtocol {
    
    typealias Model = [String: AnyObject]
    
    var pageSize: Int = PageDataSettings().pageSize
    
    func loadData(parameters: [String : AnyObject]?, page: Int, done: (([[String: AnyObject]]) -> ())?, finish: ((NSError?) -> ())?) {
        
        Alamofire.request(.GET, "https://api.github.com/search/users?q=apple").responseJSON { (response) in
            
            defer {finish?(nil)}
            
            let data = response.result.value
            guard data != nil else { return }
            let result = data as! [String: AnyObject]
            done?(result["items"] as! [[String: AnyObject]])
            
        }
    }
}


class ViewController: SiFViewController , PagingControllerProtocol, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //--------> [Step 1]
     /// Setup for paging
    
    typealias M = UsersProvider.Model
    
    var instantReloadContent: Bool = false
    
        /// provider to fetch data
    lazy var provider = UsersProvider()
    
        /// dataSource to manage data by pages
    lazy var dataSource: PageDataSource<M> = PageDataSource<M>()
    
        /// Set up scroll view to display
    var pagingScrollView: UIScrollView {
        return self.tableView
    }
    
    
    
    @IBAction func addButtonDidTapped(sender: AnyObject) {
        let viewController2 = ViewController2.instantiateViewControllerFromMainStoryboard()
        self.navigationController?.pushViewController(viewController2, animated: true)
    }
    
    
    //--------> [Step 2]
    /**
     Load first data
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.darkGrayColor()
        self.statusBarStyle = .LightContent
        
        self.loadDataPage(0, start: { [unowned self] in
            self.showLoading()
        }) { [unowned self] in
            self.hideLoading()
        }
    }
    
    
    //--------> [Step 3]
    /**
     Set up pull to refresh here
     default method setupLayout() will set up pull up/down control with SVPullRefresh
     Your can change setupLayout() to yourself settings
     */

    override func viewFinishedLayout() {
        setupLayout()
    }
    
    
    
    //--------> [Step 4]
    /**
     Implements to display data
     */
    // MARK: - Table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /**
         get list data from dataSource via pages property
         */
        return self.dataSource.pages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.lightGrayColor()
        
        let model = self.dataSource.pages[indexPath.row]
        cell.textLabel?.text = model["login"] as? String
        
        return cell
    }

}

