//
//  STwitterTestCase.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 7..
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

import XCTest

class STwitterTestCase: XCTestCase {

    let consumerKey = ProcessInfo.processInfo.environment["TWITTER_CONSUMER_KEY"] ?? ""
    let consumerSecret = ProcessInfo.processInfo.environment["TWITTER_CONSUMER_SECRET"] ?? ""
    let accessToken = ProcessInfo.processInfo.environment["TWITTER_ACCESS_TOKEN"] ?? ""
    let accessTokenSecret = ProcessInfo.processInfo.environment["TWITTER_ACCESS_TOKEN_SECRET"] ?? ""

    let uuid = UUID()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

}
