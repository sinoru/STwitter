//
//  Error.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

public enum Error: Swift.Error, CustomNSError {
    case Unknown
    
    func errorDomain() -> String {
        return "com.sinoru.STwitter.Error"
    }
    
    func userInfo() -> Dictionary<String,String>? {
        var userInfo:Dictionary<String,String>?
        if let errorString = errorDescription() {
            userInfo = [NSLocalizedDescriptionKey: errorString]
        }
        return userInfo
    }
    
    func errorDescription() -> String? {
        var errorString:String?
        switch self {
        case .Unknown:
            errorString = "Unknown Error"
        }
        return errorString
    }
    
    func errorCode() -> Int {
        switch self {
        case .Unknown:
            return -1
        }
    }
}
