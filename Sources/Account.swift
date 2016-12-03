//
//  Account.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

@objc(STWAccount)
public class Account: NSObject {
    public let oauthToken: String
    internal let oauthTokenSecret: String
    
    @objc public init(oauthToken: String, oauthTokenSecret: String) {
        self.oauthToken = oauthToken
        self.oauthTokenSecret = oauthTokenSecret
        super.init()
    }
    
    @objc public class func requestVerifyCredential(session: Session, handler: @escaping (User?, NSError?) -> Void) {
        guard let url = URL.twitterRESTAPIURL(endpoint: "account/verify_credentials.json") else {
            handler(nil, Error.unknown)
            return
        }
        
        let httpMethod = "GET"
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod
            
            let authorizationHeader = try OAuth.authorizationHeader(oauthItems: [:], HTTPMethod: httpMethod, url: url, consumerKey: session.consumerKey, consumerSecret: session.consumerSecret)
            
            urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
            
            let task = session.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    handler(nil, error as NSError?)
                    return
                }
                
                do {
                    guard let data = data else {
                        handler(nil, error as NSError?)
                        return
                    }
                    
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    
                    guard let user = User(jsonObject: jsonObject) else {
                        handler(nil, error as NSError?)
                        return
                    }
                    
                    handler(user, nil)
                }
                catch let error as NSError {
                    handler(nil, error)
                }
                catch {
                    handler(nil, Error.unknown)
                }
            })
            task.resume()
        }
        catch let error as NSError {
            handler(nil, error)
        }
        catch {
            handler(nil, Error.unknown)
        }
    }
    
}
