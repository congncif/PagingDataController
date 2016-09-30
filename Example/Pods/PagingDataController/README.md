# PagingDataController

[![CI Status](http://img.shields.io/travis/NGUYEN CHI CONG/PagingDataController.svg?style=flat)](https://travis-ci.org/NGUYEN CHI CONG/PagingDataController)
[![Version](https://img.shields.io/cocoapods/v/PagingDataController.svg?style=flat)](http://cocoapods.org/pods/PagingDataController)
[![License](https://img.shields.io/cocoapods/l/PagingDataController.svg?style=flat)](http://cocoapods.org/pods/PagingDataController)
[![Platform](https://img.shields.io/cocoapods/p/PagingDataController.svg?style=flat)](http://cocoapods.org/pods/PagingDataController)

![Screenshot](http://i.imgur.com/PTI6vMcm.png)
![Pull to refresh](http://i.imgur.com/thZpiCzm.png)
![Load more data next page](http://i.imgur.com/HhAwUKTm.png)

If you find it difficult or uncomfortable when having to write the code again while working with data paging, PagingDataController framework is a solution for you. It's simple and extremely easy to use. Let me help you get started:

S1. Provider: provider is a controller, it will retrieve data by page number
  * Creating a provider.
  * Declare the data model and page size at head. 
  * Implement ```loadData``` method
```swift
class GithubUsersViewControllerProvider: PagingProviderProtocol {
    typealias Model = [String: AnyObject]
    
    var pageSize: Int = 20
    
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
```
S2. Implement view controller conform ```PagingControllerProtocol``` protocol
  * Declare provider
```swift
    lazy var provider = GithubUsersViewControllerProvider()
```
  * Setup for paging: default using ```setupDefaultForPaging``` method. 
    + You can custom more by overriding ```pagingScrollView``` getter & return a scroll to display data (by default It auto finds a scrollView in viewController to use as ```pagingScrollView```). 
        Example:
```swift
override var pagingScrollView: UIScrollView {
  return self.tableView
}
```
You can override ```setupPullToRefreshView``` & ```setupInfiniteScrollingView``` method to trigger a pull action & load more action.

  * Override ```pullDownAction``` & ```infiniteAction``` to fetch data. Using ```loadDataPage``` to get data from provider. This method is implemented by framework. 
  
```swift
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
```

  * All done. Now you only implement a dataSource (table view datasource or collection view data source) to display result. See more details from my example in source code. Good luck!


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

PagingDataController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PagingDataController"
```

## Author

NGUYEN CHI CONG, congnc.if@gmail.com

## License

PagingDataController is available under the MIT license. See the LICENSE file for more info.
