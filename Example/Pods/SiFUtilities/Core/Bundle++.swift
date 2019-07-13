//
//  Bundle++.swift
//  SiFUtilities
//
//  Created by NGUYEN CHI CONG on 2/15/19.
//

import Foundation

extension Bundle {
    public class var current: Bundle {
        let caller = Thread.callStackReturnAddresses[1]
        
        if let bundle = _cache.object(forKey: caller) {
            return bundle
        }
        
        var info = Dl_info(dli_fname: "", dli_fbase: nil, dli_sname: "", dli_saddr: nil)
        dladdr(caller.pointerValue, &info)
        let imagePath = String(cString: info.dli_fname)
        
        for bundle in Bundle.allBundles + Bundle.allFrameworks {
            if let execPath = bundle.executableURL?.resolvingSymlinksInPath().path,
                imagePath == execPath {
                _cache.setObject(bundle, forKey: caller)
                return bundle
            }
        }
        #if DEBUG
        print("Bundle not found for caller \"\(String(cString: info.dli_sname))\"")
        #endif
        return Bundle.main
    }
    
    private static let _cache = NSCache<NSNumber, Bundle>()
}
