//
//  OAuthTests.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//
//

import XCTest
import Foundation
@testable import STwitter

class OAuthTests: XCTestCase {
    func testGenerateOAuthSignature() {
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
        
        XCTAssertEqual(try! STwitter.OAuth.generateOAuthSignature(queryItems: queryItems, HTTPMethod: HTTPMethod, url: url, consumerSecret: consumerSecret, tokenSecret: tokenSecret), "tnnArxj06cWHq44gCs1OSKk/jLY=")
    }
    
    
    static var allTests : [(String, (OAuthTests) -> () throws -> Void)] {
        return [
            ("testGenerateOAuthSignature", testGenerateOAuthSignature),
        ]
    }
}
