//
//  Account.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
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
