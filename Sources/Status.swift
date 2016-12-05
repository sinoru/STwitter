//
//  Status.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

public class Status: NSObject {
    
    var jsonObject: [String:Any]
    
    public var id: Int64
    
    internal init?(jsonObject: Any) {
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
}

extension Session {
    
    public func statusUpdateTask(status: String, possiblySensitive: Bool = false, mediae: [Media]?, completionHandler: @escaping (Status?, Swift.Error?) -> Void) throws -> StatusSessionTask {
        guard let url = URL.twitterRESTAPIURL(endpoint: "statuses/update.json") else {
            throw Error.Unknown
        }
        
        let httpMethod = "POST"
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        
        let queryItems = [
            URLQueryItem(name: "status", value: status),
            URLQueryItem(name: "possibly_sensitive", value: possiblySensitive ? "true" : "false"),
            ]
        
        let authorizationHeader = try OAuth.authorizationHeader(queryItems: queryItems, HTTPMethod: httpMethod, url: url, consumerKey: self.consumerKey, consumerSecret: self.consumerSecret, token: self.account?.oauthToken, tokenSecret: self.account?.oauthTokenSecret)
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
                completionHandler(nil, error)
                return
            }
            
            do {
                let data = try Data(contentsOf: location)
                
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                
                try TwitterError.checkTwitterError(onJsonObject: jsonObject)
                
                guard let status = Status(jsonObject: jsonObject) else {
                    completionHandler(nil, error)
                    return
                }
                
                completionHandler(status, nil)
            }
            catch let error {
                completionHandler(nil, error)
            }
        })
        
        return StatusSessionTask(urlSessionTask: urlSessionTask)
    }
}
