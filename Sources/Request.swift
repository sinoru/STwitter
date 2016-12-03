//
//  Request.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    @objc(STWRequest)
    public class Request: NSObject {
        public var account: Account?
    }
#elseif os(Linux)
    public class Request {
        public var account: Account?
    }
#endif

extension Request {
    
}
