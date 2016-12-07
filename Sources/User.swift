//
//  User.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 4..
//
//

import Foundation

@objc(STWUser)
public class User: NSObject {
    
    var jsonObject: [String:Any]
    
    /// The user ID for the account.
    @objc public var id: Int64
    /// The username for the account.
    @objc public var screenName: String
    /// The full name for the account.
    @objc public var name: String? {
        return self.jsonObject["name"] as? String
    }
    /// The profile image URL for the account.
    @objc public var profileImageURL: URL? {
        return URL(string: self.jsonObject["profile_image_url"] as? String ?? "")
    }
    
    init?(jsonObject: Any) {
        guard let jsonObject = jsonObject as? [String:Any] else {
            return nil
        }
        self.jsonObject = jsonObject
        
        guard let id = jsonObject["id"] as? Int64 else {
            return nil
        }
        self.id = id
        
        guard let screenName = jsonObject["screen_name"] as? String else {
            return nil
        }
        self.screenName = screenName
        
        super.init()
    }
}

extension Session {
    
    @objc public func fetchUserTaskForCurrentAccount(completionHandler: @escaping (User?, Swift.Error?) -> Void) throws -> UserSessionTask {
        let url = URL.twitterRESTAPIURL(endpoint: "account/verify_credentials.json")!
        
        let httpMethod = "GET"
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        
        let authorizationHeader = try OAuth.authorizationHeader(HTTPMethod: httpMethod, url: url, consumerKey: self.consumerKey, consumerSecret: self.consumerSecret, token: self.account?.accessToken, tokenSecret: self.account?.accessTokenSecret)
        urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        let urlSessionTask = self.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            do {
                guard let data = data else {
                    completionHandler(nil, Error.Unknown)
                    return
                }
                
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                
                try TwitterError.checkTwitterError(onJsonObject: jsonObject)
                
                guard let user = User(jsonObject: jsonObject) else {
                    completionHandler(nil, Error.Unknown)
                    return
                }
                
                completionHandler(user, nil)
            }
            catch let error {
                completionHandler(nil, error)
            }
        })
        
        let userSessionTask = UserSessionTask(urlSessionTask: urlSessionTask)
        
        return userSessionTask
    }
}

