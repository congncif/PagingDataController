//
//  UITableView++.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 7/13/19.
//

import Foundation
import UIKit

extension UITableView {
    public func sizeHeaderToFit() {
        if let headerView = tableHeaderView {
            headerView.layoutIfNeeded()
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = headerView.frame
            if height != frame.height {
                frame.size.height = height
                headerView.frame = frame
                tableHeaderView = headerView
            }
        }
    }

    public func sizeFooterToFit() {
        if let footerView = tableFooterView {
            footerView.layoutIfNeeded()
            let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var frame = footerView.frame
            if height != frame.height {
                frame.size.height = height
                footerView.frame = frame
                tableFooterView = footerView
            }
        }
    }
}
