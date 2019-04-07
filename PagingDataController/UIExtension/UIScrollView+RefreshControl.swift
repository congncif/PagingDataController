//
//  UIViewController+PagingData.swift
//  PagingDataControllerExtension
//
//  Created by NGUYEN CHI CONG on 8/11/16.
//  Copyright © 2016 FOLY. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    public var nativeRefreshControl: UIRefreshControl? {
        if #available(iOS 10.0, *) {
            return refreshControl
        } else {
            return subviews.filter { (subview) -> Bool in
                subview is UIRefreshControl
            }.first as? UIRefreshControl
        }
    }
}
