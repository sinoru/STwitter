//
//  UserTests.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 5..
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
