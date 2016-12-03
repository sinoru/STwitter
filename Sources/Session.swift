//
//  Session.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//
//

import Foundation

public class Session: NSObject {
    public var account: Account?
    
    public var consumerKey: String
    public var consumerSecret: String
    
    internal let urlSession: URLSession
    
    init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.urlSession = URLSession()
        super.init()
    }
}
