//
//  Session.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//
//

import Foundation

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    @objc(STWSession)
    public class Session: NSObject {
        
        public var account: Account?
        
        public var consumerKey: String
        public var consumerSecret: String
        
        internal let urlSession: URLSession
        
        init(consumerKey: String, consumerSecret: String) {
            self.consumerKey = consumerKey
            self.consumerSecret = consumerSecret
            self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
            super.init()
        }
    }
#elseif os(Linux)
    public class Session {
        
        public var account: Account?
        
        public var consumerKey: String
        public var consumerSecret: String
        
        internal let urlSession: URLSession
        
        init(consumerKey: String, consumerSecret: String) {
            self.consumerKey = consumerKey
            self.consumerSecret = consumerSecret
            self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
            super.init()
        }
    }
#endif

extension Session {
    
    
}
