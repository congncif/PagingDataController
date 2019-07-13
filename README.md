# PagingDataControllerExtension

<img src="https://i.imgur.com/ATK9hZV.png"/>


[![Version](https://img.shields.io/cocoapods/v/PagingDataController.svg?style=flat)](http://cocoapods.org/pods/PagingDataController)
[![License](https://img.shields.io/cocoapods/l/PagingDataController.svg?style=flat)](http://cocoapods.org/pods/PagingDataController)
[![Platform](https://img.shields.io/cocoapods/p/PagingDataController.svg?style=flat)](http://cocoapods.org/pods/PagingDataController)


**PagingDataController** is a library for implementing loading data by page (pagination) easily. It provides a short setup via few lines of code. You will not need to worry about page management, when to load the next page's data, and so on.

**PagingDataControllerExtension** is built with `SVPullToRefresh`. So you do not have to manually add controls. But you can customize everything if you want.

![Screenshot](http://i.imgur.com/PTI6vMcm.png)
![Pull to refresh](http://i.imgur.com/thZpiCzm.png)
![Load more data next page](http://i.imgur.com/HhAwUKTm.png)

## Requirements

- iOS 8.0+
- Xcode 8.3+
- Swift 3.1+

## Installation

PagingDataControllerExtension is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PagingDataControllerExtension"
```

## How it works?

<img src="https://i.imgur.com/ExwdwgR.jpg"/>

**Provider** is a component which handles loading data by page. A list of objects or error will be returned once it is finished in processing.

**DataSource** keeps all of data which loaded by provider and arranges them in order of page.

A controller which implements `PagingDataController` includes a provider and a dataSource itself. While `dataSource` is injected automatically, `provider` needs to be declared explicit.

## Usage

1. Create a new project.
2. In `ViewController.swift`, add a `tableView` or `collectionView` to display list of items.
3. Create `Provider`:

```swift
struct GithubUsersProvider: PagingProviderProtocol {
    // custom pageSize here
    var pageSize: Int = 36

    func loadData(parameters: AnyObject?, page: Int, completion: @escaping ([[String: AnyObject]], Error?) -> Void) {
        let apiPath = "https://api.github.com/search/users?q=apple&page=\(page + 1)&per_page=\(pageSize)"
        Alamofire.request(apiPath, method: .get).responseJSON { response in
            var error: Error? = response.result.error
            var result: [[String: AnyObject]] = []

            defer {
                completion(result, error)
            }

            guard let data = (response.result.value as? [String: AnyObject]) else {
                return
            }
            result = data["items"] as! [[String: AnyObject]]
        }
    }
}
```

4. In `ViewController.swift`, Implement the methods of `UITableViewDataSource` or `UICollectionViewDataSource` to render data, make it conforms protocol `PagingControllerProtocol`

```swift
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
```
5. Build & Run to enjoy

<img src="https://i.imgur.com/PFa9mJ2.png" width=375/>

## Author

NGUYEN CHI CONG, congnc.if@gmail.com

## License

PagingDataControllerExtension is available under the MIT license. See the LICENSE file for more info.
