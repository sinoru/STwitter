//
//  Session.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//
//

import Foundation

@objc(STWSession)
public class Session: NSObject {
    public var account: Account?
    
    public var consumerKey: String
    public var consumerSecret: String
    
    internal let urlSession: URLSession
    
    @objc public init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
        super.init()
    }
    
    @objc public func requestVerifyAccountCredential(handler: @escaping (User?, NSError?) -> Void) {
        guard let url = URL.twitterRESTAPIURL(endpoint: "account/verify_credentials.json") else {
            handler(nil, Error.unknown)
            return
        }
        
        let httpMethod = "GET"
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod
            
            let authorizationHeader = try OAuth.authorizationHeader(oauthItems: [:], HTTPMethod: httpMethod, url: url, consumerKey: self.consumerKey, consumerSecret: self.consumerSecret)
            
            urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
            
            let task = self.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
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
