//
//  UserTests.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 5..
//
//

import XCTest
import Foundation
@testable import STwitter

class UserTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFetchUserForCurrentAccount() {
        let consumerKey = ProcessInfo.processInfo.environment["TWITTER_CONSUMER_KEY"] ?? ""
        let consumerSecret = ProcessInfo.processInfo.environment["TWITTER_CONSUMER_SECRET"] ?? ""
        let accessToken = ProcessInfo.processInfo.environment["TWITTER_ACCESS_TOKEN"] ?? ""
        let accessTokenSecret = ProcessInfo.processInfo.environment["TWITTER_ACCESS_TOKEN_SECRET"] ?? ""
        
        let session = STwitter.Session(consumerKey: consumerKey, consumerSecret: consumerSecret)
        
        let account = STwitter.Account(oauthToken: accessToken, oauthTokenSecret: accessTokenSecret)
        session.account = account
        
        let expectation = self.expectation(description: "Fetch User for current account")
        
        let task = try! session.fetchUserTaskForCurrentAccount { (user, error) in
            XCTAssertNotNil(user)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        task.resume()
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    static var allTests : [(String, (UserTests) -> () throws -> Void)] {
        return [
            ("testFetchUserForCurrentAccount", testFetchUserForCurrentAccount)
        ]
    }
}
