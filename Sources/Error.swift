//
//  Error.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//  Copyright © 2016 Sinoru. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

/// Generic Error
public enum Error: Swift.Error, CustomNSError {
    /// Unknown Error
    case Unknown

    func errorDomain() -> String {
        return "com.sinoru.STwitter.Error"
    }

    func userInfo() -> [String:String]? {
        var userInfo: [String:String]?
        if let errorString = errorDescription() {
            userInfo = [NSLocalizedDescriptionKey: errorString]
        }
        return userInfo
    }

    func errorDescription() -> String? {
        var errorString: String?
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

/// Twitter Error
///
/// - seealso:
///     [Error Codes & Responses](https://dev.twitter.com/overview/api/response-codes) from Twitter Developer Documentation
public enum TwitterError: Swift.Error, CustomNSError {
    /// Your credentials do not allow access to this resource.
    case NotAllowed
    /// Other wrapper for unknown error from Twitter.
    case Other(code: Int, message: String?)

    func errorDomain() -> String {
        return "com.sinoru.STwitter.Twitter.Error"
    }

    func userInfo() -> [String:String]? {
        var userInfo: [String:String]?
        if let errorString = errorDescription() {
            userInfo = [NSLocalizedDescriptionKey: errorString]
        }
        return userInfo
    }

    func errorDescription() -> String? {
        var errorString: String?
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
