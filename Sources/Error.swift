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

public enum TwitterError: Swift.Error, CustomNSError {
    case NotAllowed
    case Other(code: Int, message: String?)
    
    func errorDomain() -> String {
        return "com.sinoru.STwitter.Twitter.Error"
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
        case .NotAllowed:
            errorString = "Your credentials do not allow access to this resource."
        case .Other(_, let message):
            errorString = message ?? ""
        }
        return errorString
    }
    
    func errorCode() -> Int {
        switch self {
        case .NotAllowed:
            return 220
        case .Other(let code, _):
            return code
        }
    }
    
    static func checkTwitterError(onJsonObject jsonObject: Any?) throws {
        guard let jsonObject = jsonObject as? [String:Any] else {
            return
        }
        
        guard let error = (jsonObject["errors"] as? [[String:Any]])?.first else {
            return
        }
        
        guard let code = error["code"] as? Int else {
            return
        }
        
        switch code {
        case 220:
            throw self.NotAllowed
        default:
            let message = error["message"] as? String
            throw self.Other(code: code, message: message)
        }
    }
}
