# PagingDataControllerExtension

<blockquote class="imgur-embed-pub" lang="en" data-id="a/Jg05D"><a href="//imgur.com/Jg05D"></a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>
[![Version](https://img.shields.io/cocoapods/v/PagingDataControllerExtension.svg?style=flat)](http://cocoapods.org/pods/PagingDataControllerExtension)
[![License](https://img.shields.io/cocoapods/l/PagingDataControllerExtension.svg?style=flat)](http://cocoapods.org/pods/PagingDataControllerExtension)
[![Platform](https://img.shields.io/cocoapods/p/PagingDataControllerExtension.svg?style=flat)](http://cocoapods.org/pods/PagingDataControllerExtension)

**PagingDataController** is a library for implementing loading data by page (pagination) easily. It provides a short setup via few lines of code. You will not need to worry about page management, when to load the next page's data, and so on.

**PagingDataControllerExtension** is built with `SVPullToRefresh`. So you do not have to manually add controls. But you can customize everything if you want.

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

## Author

NGUYEN CHI CONG, congnc.if@gmail.com

## License

PagingDataControllerExtension is available under the MIT license. See the LICENSE file for more info.

## How it works?

<blockquote class="imgur-embed-pub" lang="en" data-id="a/4heFr"><a href="//imgur.com/4heFr"></a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>

**Provider** is a component which handles loading data by page. A list of objects or error will be returned once it is finished in processing.

**DataSource** keeps all of data which loaded by provider and arrange them in order of page.

A controller which implements `PagingDataController` includes a provider and a dataSource itself. While `dataSource` is injected automatically, `provider` needs to be declared explicit.

## Usage

1. Create a new project.
2. In `ViewController.swift`, add a `tableView` or `collectionView` to display list of items.
3. Create `Provider`:

```swift

import UIKit
import PagingDataController
import Alamofire

struct GithubUsersProvider: PagingProviderProtocol {
    
    //custom pageSize here
    var pageSize: Int = 36
    
    func loadData(parameters: AnyObject?, page: Int, completion: (([Dictionary<String, AnyObject>], Error?) -> ())?) {
        
        let apiPath = "https://api.github.com/search/users?q=apple&page=\(page+1)&per_page=\(pageSize)"
        Alamofire.request(apiPath, method: .get).responseJSON { (response) in
            var error: Error? = response.result.error
            var result: [[String: AnyObject]] = []
            
            defer {
                completion?(result, error)
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
//Provider definition
lazy var provider = GithubUsersProvider()
```

Copy this method and put it below `viewDidLoad()`:

```swift
override func viewDidFinishLayout() {
	super.viewDidFinishLayout()
    setupForPaging()
}
```

* To custom parameters, implement this method ```parametersForPage(_:)```
* To error handling, implement this method ```errorWarningForPage(_:)```

5. Build & Run to enjoy

<blockquote class="imgur-embed-pub" lang="en" data-id="a/ZWXpn"><a href="//imgur.com/ZWXpn"></a></blockquote><script async src="//s.imgur.com/min/embed.js" charset="utf-8"></script>