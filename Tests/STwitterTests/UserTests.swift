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

class UserTests: STwitterTestCase {

    func testFetchUserForCurrentAccount() {
        let session = STwitter.Session(consumerKey: self.consumerKey, consumerSecret: self.consumerSecret)

        let account = STwitter.Account(accessToken: self.accessToken, accessTokenSecret: self.accessTokenSecret)
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

    static var allTests: [(String, (UserTests) -> () throws -> Void)] {
        return [
            ("testFetchUserForCurrentAccount", testFetchUserForCurrentAccount)
        ]
    }
}
