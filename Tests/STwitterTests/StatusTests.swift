//
//  StatusTests.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 7..
//
//

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
        
        let account = STwitter.Account(oauthToken: self.accessToken, oauthTokenSecret: self.accessTokenSecret)
        session.account = account
        
        let expectation = self.expectation(description: "Update Status")
        
        let task = try! session.statusUpdateTask(status: "Test! \(UUID().uuidString)", possiblySensitive: false, mediae: nil, completionHandler: { (status, error) in
            XCTAssertNotNil(status)
            XCTAssertNil(error)
            
            expectation.fulfill()
        })
        task.resume()
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

}
