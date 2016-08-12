//
//  GithubUsersViewController.swift
//  PagingDataController
//
//  Created by FOLY on 8/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import PagingDataController
import SiFUtilities
import SDWebImage

class GithubUsersViewController: UIViewController , PagingControllerProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    //Provider definition
    lazy var provider = GithubUsersViewControllerProvider()
    
    //setup default
    override func viewFinishedLayout() {
        super.viewFinishedLayout()
        
        self.setupDefaultForPaging()
        self.dataSource.delegate = self

        self.loadData()
    }
    
    override func pullDownAction(end: (() -> ())? = nil) {
        loadFirstPage(end)
    }
    
    override func infiniteAction(end: (() -> ())? = nil) {
        loadNextPage(end)
    }


    //load data
    func loadData() {
        self.loadDataPage(0, start: { [unowned self] in
            self.showLoading()
        }) { [unowned self] in
            self.pagingScrollView.reloadContent()
            self.hideLoading()
        }
    }
    
    
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
        return self.dataSource.allObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let model = objectAtIndex(indexPath.row)
        
        let url = NSURL(string: model["avatar_url"] as! String)
        let imageView = cell.viewWithTag(1) as? UIImageView
        imageView?.sd_setImageWithURL(url)
        
        let titleLabel = cell.viewWithTag(2) as? UILabel
        titleLabel?.text = model["login"] as? String
        
        let homeUrl = model["html_url"] as? String
        let homeLabel = cell.viewWithTag(3) as? UILabel
        homeLabel?.text = homeUrl
        
        return cell
    }


}
