//
//  Account.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

@objc(STWAccount)
public class Account: NSObject {
    @objc public let oauthToken: String
    let oauthTokenSecret: String
    
    @objc public init(oauthToken: String, oauthTokenSecret: String) {
        self.oauthToken = oauthToken
        self.oauthTokenSecret = oauthTokenSecret
        super.init()
    }
    
}
