# PagingDataController

[![Version](https://img.shields.io/cocoapods/v/PagingDataController.svg?style=flat)](http://cocoapods.org/pods/PagingDataController)
[![License](https://img.shields.io/cocoapods/l/PagingDataController.svg?style=flat)](http://cocoapods.org/pods/PagingDataController)
[![Platform](https://img.shields.io/cocoapods/p/PagingDataController.svg?style=flat)](http://cocoapods.org/pods/PagingDataController)

![Screenshot](http://i.imgur.com/PTI6vMcm.png)
![Pull to refresh](http://i.imgur.com/thZpiCzm.png)
![Load more data next page](http://i.imgur.com/HhAwUKTm.png)

If you find it difficult or uncomfortable when having to write the code again while working with data paging, PagingDataController framework is a solution for you. It's simple and extremely easy to use. Let me help you get started:

### Requirements
* XCode 8+
* Swift 3+
* iOS 8+

## Installation

PagingDataController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PagingDataControllerExtension'
```

## Author

NGUYEN CHI CONG, congnc.if@gmail.com

## License

PagingDataController is available under the MIT license. See the LICENSE file for more info.

### Getting started

1. **Provider**: provider is a controller, it will retrieve data by page number
  * Creating a provider.
  * Implement ```loadData``` method
```swift
struct GithubUsersProvider: PagingProviderProtocol {
    
    //custom pageSize here
    var pageSize: Int = 36
    
    
    /*******************************************************************************************************
     * Replace type of Parameters and Return model to custom type in your app
     * Example:
     * func loadData(_ parameters: <#ParamterType#>?, page: Int, completion: (([<#ReturnType#>], Error?) -> ())?)
     *******************************************************************************************************/
    
    func loadData(_ parameters: AnyObject?, page: Int, completion: (([Dictionary<String, AnyObject>], Error?) -> ())?) {
        
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
2. Implement view controller conform `PagingControllerProtocol` protocol

```swift
class GithubUsersViewController: UIViewController , PagingControllerProtocol {
[...]
}
```

  * Declare provider to get data by page. Replace provider by your provider.
```swift
    lazy var provider = GithubUsersProvider()
```
  * Setup for paging data. All you have to do is copying the below method into your view controller.
```swift
    /******************************************
     Copy this method into your view controller
    ******************************************/
    override func viewDidFinishLayout() {
        super.viewDidFinishLayout()
        setupForPaging()
    }
```

  * **All done. Too easy, right?. Good luck!**

