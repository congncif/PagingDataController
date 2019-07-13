//
//  GithubUsersViewController.swift
//  PagingDataController
//
//  Created by FOLY on 8/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import PagingDataController
import SDWebImage
import SiFUtilities
import UIKit

// 🚀 Just 4 steps to setup a Paging View Controller

class GithubUsersViewController: UIViewController, PagingControllerProtocol, PagingViewControllable {
    @IBOutlet var tableView: UITableView!

    // 1️⃣ [Step 1]: Provider definition.
    lazy var provider = GithubUsersProvider()

    // 2️⃣ [Step 2]: setup paging in single line of code.
    /******************************************
     Copy this method into your view controller
     ******************************************/
    override func viewDidFinishInitialLayout() {
        setupPagingController()
    }

    // 3️⃣ [Step 3]: Pass parameters for fetching data by page, default is nil.

    func parametersForPage(_ page: Int) -> AnyObject? {
        return nil
    }

    // 4️⃣ [Step 4]: Handle error when fetching failed.

    func errorWarningForPage(_ page: Int, error: Error) {
        showErrorAlert(error)
    }
}

// MARK: - Actions

extension GithubUsersViewController {
    //////////////////////////////////////////////////////////////////////////////////////
    @IBAction private func refreshButtonDidTapped(_ sender: AnyObject) {
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        refreshPaging()
    }
}

// MARK: - TableView DataSource

extension GithubUsersViewController: UITableViewDataSource {
    /****************************
     Implement to display data
     ****************************/

    //////////////////////////////////////////////////////////////////////////////////////

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.allObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
