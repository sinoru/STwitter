//
//  Error.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    @objc(STWError)
    class Error: NSError {
        
    }
#elseif os(Linux)
    class Error: NSError {
        
    }
#endif

extension Error {
    class var unknown: Error {
        return Error(domain: "", code: -1)
    }
}
