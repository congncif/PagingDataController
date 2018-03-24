//
//  UIViewController+Alert.swift
//  SiFUtilities
//
//  Created by FOLY on 2/4/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    open func confirm(title: String? = nil,
                        message: String? = nil,
                        cancelTitle: String = LocalizedString("Cancel"),
                        cancelHandler: @escaping ()->Void = {},
                        confirmedTitle: String = LocalizedString("OK"),
                        confirmedHandler: @escaping ()->Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { _ in
            cancelHandler()
        }))
        alert.addAction(UIAlertAction(title: confirmedTitle, style: .default, handler: { (_) in
            confirmedHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    open func notify(title: String? = nil,
                       message: String? = nil,
                       buttonTitle: String = LocalizedString("OK"),
                       handler: @escaping ()->Void = {}) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: { _ in
            handler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
