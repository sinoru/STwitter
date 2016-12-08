//
//  Status.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

@objc(STWStatus)
public class Status: NSObject {

    var jsonObject: [String:Any]

    @objc public var id: Int64

    @objc public init?(jsonObject: Any) {
        guard let jsonObject = jsonObject as? [String:Any] else {
            return nil
        }
        self.jsonObject = jsonObject

        guard let id = jsonObject["id"] as? Int64 else {
            return nil
        }
        self.id = id

        super.init()
    }

    @objc public class func statuses(jsonObjects: [Any]) -> [Status] {
        return jsonObjects.flatMap({Status(jsonObject: $0)})
    }
}

extension Session {

    @objc public func statusUpdateTask(status: String, possiblySensitive: Bool = false, mediae: [Media]?, completionHandler: @escaping (Status?, Swift.Error?) -> Void) throws -> StatusSessionTask {
        guard let url = URL.twitterRESTAPIURL(endpoint: "statuses/update.json") else {
            throw Error.Unknown
        }

        let httpMethod = "POST"

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod

        var queryItems = [
            URLQueryItem(name: "status", value: status),
            URLQueryItem(name: "possibly_sensitive", value: possiblySensitive ? "true" : "false"),
            ]

        if let mediae = mediae, mediae.count > 0 {
            queryItems.append(URLQueryItem(name: "media_ids", value: mediae.map({String($0.id)}).joined(separator: ",")))
        }

        let authorizationHeader = try OAuth.authorizationHeader(queryItems: queryItems, HTTPMethod: httpMethod, url: url, consumerKey: self.consumerKey, consumerSecret: self.consumerSecret, token: self.account?.accessToken, tokenSecret: self.account?.accessTokenSecret)
        urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")

        var urlComponents = URLComponents()
        urlComponents.queryItems = queryItems

        urlRequest.httpBody = urlComponents.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: CharacterSet.twitterAllowedCharacters)?.data(using: .utf8)

        let urlSessionTask = self.urlSession.downloadTask(with: urlRequest, completionHandler: { (location, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }

            guard let location = location else {
                completionHandler(nil, Error.Unknown)
                return
            }

            do {
                let data = try Data(contentsOf: location)

                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])

                try TwitterError.checkTwitterError(onJsonObject: jsonObject)

                guard let status = Status(jsonObject: jsonObject) else {
                    completionHandler(nil, Error.Unknown)
                    return
                }

                completionHandler(status, nil)
            } catch let error {
                completionHandler(nil, error)
            }
        })

        return StatusSessionTask(urlSessionTask: urlSessionTask)
    }
}
