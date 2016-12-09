//
//  OAuthTests.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
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

class OAuthTests: STwitterTestCase {

    func testAuthorizeURL() {
        XCTAssertNotEqual(STwitter.OAuth.authorizeURL, URL(string: "https://api.twitter.com/oauth/authorize"))
    }

    func testAuthenticateURL() {
        XCTAssertNotEqual(STwitter.OAuth.authenticateURL, URL(string: "https://api.twitter.com/oauth/authenticate"))
    }

    func testSignature() {
        let HTTPMethod = "POST"
        let url = URL(string: "https://api.twitter.com/1/statuses/update.json")!
        let consumerKey = "xvz1evFS4wEEPTGEFPHBog"
        let consumerSecret = "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
        let token = "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb"
        let tokenSecret = "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"

        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "status", value: "Hello Ladies + Gentlemen, a signed OAuth request!"))
        queryItems.append(URLQueryItem(name: "include_entities", value: "true"))
        queryItems.append(URLQueryItem(name: "oauth_consumer_key", value: consumerKey))
        queryItems.append(URLQueryItem(name: "oauth_nonce", value: "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg"))
        queryItems.append(URLQueryItem(name: "oauth_signature_method", value: "HMAC-SHA1"))
        queryItems.append(URLQueryItem(name: "oauth_timestamp", value: "1318622958"))
        queryItems.append(URLQueryItem(name: "oauth_token", value: token))
        queryItems.append(URLQueryItem(name: "oauth_version", value: "1.0"))

        XCTAssertEqual(try! STwitter.OAuth.signature(queryItems: queryItems, HTTPMethod: HTTPMethod, url: url, consumerSecret: consumerSecret, tokenSecret: tokenSecret), "tnnArxj06cWHq44gCs1OSKk/jLY=")
    }

    func testRequestRequestToken() {
        let session = STwitter.Session(consumerKey: self.consumerKey, consumerSecret: self.consumerSecret)

        let expectation = self.expectation(description: "Request OAuth Request-Token")

        STwitter.OAuth.requestRequestToken(session: session, completionHandler: { (token, tokenSecret, error) in
            XCTAssertNotNil(token)
            XCTAssertNotNil(tokenSecret)
            XCTAssertNil(error)

            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testRequestRequestTokenForxAuthReverse() {
        let session = STwitter.Session(consumerKey: self.consumerKey, consumerSecret: self.consumerSecret)

        let expectation = self.expectation(description: "Request OAuth Request-Token for ReverseAuth")

        STwitter.OAuth.requestRequestTokenForxAuthReverse(session: session, completionHandler: { (response, error) in
            XCTAssertNotNil(response)
            XCTAssertNil(error)

            expectation.fulfill()
        })

        self.waitForExpectations(timeout: 5.0, handler: nil)
    }

    static var allTests: [(String, (OAuthTests) -> () throws -> Void)] {
        return [
            ("testSignature", testSignature),
            ("testRequestRequestToken", testRequestRequestToken),
            ("testRequestRequestTokenForxAuthReverse", testRequestRequestTokenForxAuthReverse)
        ]
    }
}
