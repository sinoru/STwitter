//
//  URL.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//
//

import Foundation

extension URL {

    static func twitterRESTAPIURL(version: String = "1.1", endpoint: String) -> URL? {
        return self.init(string: endpoint, relativeTo: URL(string: "https://api.twitter.com/\(version)/"))
    }

    static func twitterOAuthURL(endpoint: String) -> URL? {
        return self.init(string: endpoint, relativeTo: URL(string: "https://api.twitter.com/oauth/"))
    }

    static func twitterUploadAPIURL(version: String = "1.1", endpoint: String) -> URL? {
        return self.init(string: endpoint, relativeTo: URL(string: "https://upload.twitter.com/\(version)/"))
    }
}
