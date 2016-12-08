//
//  STwitterTestCase.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 7..
//
//

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
