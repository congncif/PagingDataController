//
//  GithubUsersViewController.swift
//  PagingDataController
//
//  Created by FOLY on 8/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SiFUtilities
import PagingDataController
import PagingDataControllerExtension
import SDWebImage

class GithubUsersViewController: UIViewController , PagingControllerProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    //Provider definition
    lazy var provider = GithubUsersProvider()
    
    //setup default
    /******************************************
     Copy this method into your view controller
    ******************************************/
    override func viewDidFinishLayout() {
        super.viewDidFinishLayout()
        setupForPaging()
    }
    
    
    
    // MARK: - Actions
    //////////////////////////////////////////////////////////////////////////////////////
    @IBAction func refreshButtonDidTapped(_ sender: AnyObject) {
        tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        loadDataAtFirst()
    }
    
    
    
    /****************************
     Implement to display data
     ****************************/
    
    // MARK: - Table
    //////////////////////////////////////////////////////////////////////////////////////
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /**
         get list data from dataSource via pages property
         */
        return self.dataSource.allObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let model = pageObjectAtIndex(indexPath.row)
        
        let url = URL(string: model["avatar_url"] as! String)
        let imageView = cell.viewWithTag(1) as? UIImageView
        imageView?.sd_setImage(with: url)
        
        let titleLabel = cell.viewWithTag(2) as? UILabel
        titleLabel?.text = model["login"] as? String
        
        let homeUrl = model["html_url"] as? String
        let homeLabel = cell.viewWithTag(3) as? UILabel
        homeLabel?.text = homeUrl
        
        return cell
    }

}
