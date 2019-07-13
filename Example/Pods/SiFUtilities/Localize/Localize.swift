//
//  Common.swift
//  SiFUtilities
//
//  Created by FOLY on 2/4/17.
//  Copyright © 2017 [iF] Solution. All rights reserved.
//

import Foundation
import Localize_Swift

struct RunTimeKey {
    static var localizedTextKey: UInt8 = 0
    static var localizedPlaceholderTextKey: UInt8 = 1
    static var localizedImageNameKey: UInt8 = 3
    static var localizedNormalTitleKey: UInt8 = 4
    static var localizedSelectedTitleKey: UInt8 = 5
    static var localizedTitleKey: UInt8 = 6
    static var localizedBackTitleKey: UInt8 = 7
    static var localizedArrayKey: UInt8 = 8
}

public func LocalizedString(_ string: String, tableName: String? = nil) -> String {
    return NSLocalizedString(string, tableName: tableName, comment: string)
}

public protocol Localizable {
    var localized: String { get }
}

extension String: Localizable {
    public var localized: String {
        return localized()
    }
}

@objc public protocol LocalizeRenderable: class {
    func registerLocalizeUpdateNotification()
    func unregisterLocalizeUpdateNotification()
    func updateLocalize()
}

extension NSObject: LocalizeRenderable {
    @objc open func registerLocalizeUpdateNotification() {
        unregisterLocalizeUpdateNotification()

        NotificationCenter.default.addObserver(self, selector: #selector(updateLocalize), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }

    @objc open func unregisterLocalizeUpdateNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }

    @objc open func updateLocalize() {}
}

extension AssociatedObject where Self: NSObject {
    func getStringValue(by runtimeKey: inout UInt8) -> String? {
        return getAssociatedObject(key: &runtimeKey)
    }

    func setStringValue(_ newValue: String?, forRuntimeKey key: inout UInt8) {
        setAssociatedObject(key: &key, value: newValue)

        if let value = newValue, !value.isEmpty {
            registerLocalizeUpdateNotification()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
                self?.updateLocalize()
            }
        } else {
            unregisterLocalizeUpdateNotification()
        }
    }
}
