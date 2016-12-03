//
//  Session.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//
//

import Foundation

@objc(STWSession)
public class Session: NSObject {
    public var account: Account?
    
    public var consumerKey: String
    public var consumerSecret: String
    
    internal let urlSession: URLSession
    
    @objc public init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
        super.init()
    }
}
