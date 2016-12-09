//
//  StatusTests.swift
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
import Foundation
@testable import STwitter

class StatusTests: STwitterTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStatusUpdate() {
        let session = STwitter.Session(consumerKey: self.consumerKey, consumerSecret: self.consumerSecret)

        let account = STwitter.Account(accessToken: self.accessToken, accessTokenSecret: self.accessTokenSecret)
        session.account = account

        let expectation = self.expectation(description: "Update Status")

        let task = try! session.statusUpdateTask(status: "STwitter Unit Test! - (\(URL(fileURLWithPath: #file).lastPathComponent)#\(#line), \(self.uuid.uuidString[self.uuid.uuidString.startIndex..<self.uuid.uuidString.index(self.uuid.uuidString.startIndex, offsetBy: 8)])))", possiblySensitive: false, mediae: nil, completionHandler: { (status, error) in
            XCTAssertNotNil(status)
            XCTAssertNil(error)

            expectation.fulfill()
        })
        task.resume()

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

}
