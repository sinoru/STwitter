//
//  Error.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

@objc (STWError)
class Error: NSError {
    class var unknown: Error {
        return Error(domain: "", code: -1)
    }
}
