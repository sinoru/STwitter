//
//  Account.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

public class Account: NSObject {
    public let oauthToken: String
    internal let oauthTokenSecret: String
    
    public init(oauthToken: String, oauthTokenSecret: String) {
        self.oauthToken = oauthToken
        self.oauthTokenSecret = oauthTokenSecret
        super.init()
    }
}
