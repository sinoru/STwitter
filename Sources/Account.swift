//
//  Account.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

/// A class that interact with Session to authenticate API endpoints.
@objc(STWAccount)
public class Account: NSObject {
    /// OAuth access token.
    @objc public let accessToken: String
    let accessTokenSecret: String
    
    /// Initialize Account object.
    ///
    /// - Parameters:
    ///   - accessToken: A OAuth acess token.
    ///   - accessTokenSecret: A OAuth access token secret.
    @objc public init(accessToken: String, accessTokenSecret: String) {
        self.accessToken = accessToken
        self.accessTokenSecret = accessTokenSecret
        super.init()
    }
    
}
