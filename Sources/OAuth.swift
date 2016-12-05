//
//  OAuth.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation
import Cryptor

@objc(STWOAuth)
public class OAuth: NSObject {
    @objc(STWXAuthMode)
    public enum xAuthMode: UInt {
        case None = 0
        case ClientAuth = 1
        case ReverseAuth = 2
    }
    
    @objc public class func requestRequestToken(session: Session, xAuthMode: xAuthMode = .None, callback: String = "oob", handler: @escaping (String?, String?, Swift.Error?) -> Void) {
        let url = URL.twitterOAuthURL(endpoint: "request_token")!
        
        let httpMethod = "POST"
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod
            
            var oauthItems = ["oauth_callback": callback]
            
            // TODO: xAuth
            
            let authorizationHeader = try self.authorizationHeader(oauthItems: oauthItems, HTTPMethod: httpMethod, url: url, consumerKey: session.consumerKey, consumerSecret: session.consumerSecret, token: nil, tokenSecret: nil)
            
            urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
            
            let task = session.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    handler(nil, nil, error)
                    return
                }
                
                do {
                    let (token, tokenSecret, userInfo) = try self.processOAuth(response: response, data: data)
                    
                    guard let callbackConfirmed = Bool((userInfo["oauth_callback_confirmed"] ?? nil) ?? "false"), callbackConfirmed == true else {
                        handler(nil, nil, Error.Unknown)
                        return
                    }
                    
                    handler(token, tokenSecret, nil)
                }
                catch let error {
                    handler(nil, nil, error)
                }
            })
            task.resume()
        }
        catch let error {
            handler(nil, nil, error)
        }
    }
    
    @objc public class func requestAccessToken(session: Session, requestToken: String, requestTokenSecret: String, xAuthMode: xAuthMode = .None, xAuthUsername: String? = nil, xAuthPassword: String? = nil, oauthVerifier: String? = nil, handler: @escaping (String?, String?, Int64, String?, Swift.Error?) -> Void) {
        let url = URL.twitterOAuthURL(endpoint: "access_token")!
        
        let httpMethod = "POST"
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod
            
            var oauthItems = [String:String]()
            
            if let oauthVerifier = oauthVerifier {
                oauthItems["oauth_verifier"] = oauthVerifier
            }
            
            // TODO: xAuth
            
            let authorizationHeader = try self.authorizationHeader(oauthItems: oauthItems, HTTPMethod: httpMethod, url: url, consumerKey: session.consumerKey, consumerSecret: session.consumerSecret, token: requestToken, tokenSecret: requestTokenSecret)
            
            urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
            
            let task = session.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    handler(nil, nil, -1, nil, error)
                    return
                }
                
                do {
                    let (token, tokenSecret, userInfo) = try self.processOAuth(response: response, data: data)
                    
                    let userID: Int64 = Int64((userInfo["user_id"] ?? "") ?? "") ?? -1
                    let screenName = userInfo["screen_name"] ?? nil
                    
                    handler(token, tokenSecret, userID, screenName, nil)
                }
                catch let error {
                    handler(nil, nil, -1, nil, error)
                }
            })
            task.resume()
        }
        catch let error {
            handler(nil, nil, -1, nil, error)
        }
    }
    
    internal class func processOAuth(response: URLResponse?, data: Data?) throws -> (token: String, tokenSecret: String, userInfo: [String:String?]) {
        guard let response = response as? HTTPURLResponse, 200 <= response.statusCode && response.statusCode < 300 else {
            throw Error.Unknown
        }
        
        guard let data = data else {
            throw Error.Unknown
        }
        
        guard let queryString = String(data: data, encoding: .utf8) else {
            throw Error.Unknown
        }
        
        var urlComponents = URLComponents()
        urlComponents.percentEncodedQuery = queryString
        
        guard let queryItems = urlComponents.queryItems else {
            throw Error.Unknown
        }
        
        var items = [String:String?]()
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        
        guard let token = items["oauth_token"] ?? nil, let tokenSecret = items["oauth_token_secret"] ?? nil else {
            throw Error.Unknown
        }
        
        items.removeValue(forKey: "oauth_token")
        items.removeValue(forKey: "oauth_token_secret")
        
        return (token, tokenSecret, items)
    }
    
    internal class func authorizationHeader(queryItems: [URLQueryItem] = [], oauthItems: [String:String] = [:], HTTPMethod: String, url: URL, consumerKey: String, consumerSecret: String, token: String?, tokenSecret: String?) throws -> String {
        var authorizationHeaderQueryItems = [
            URLQueryItem(name: "oauth_consumer_key", value: consumerKey),
            URLQueryItem(name: "oauth_signature_method", value: "HMAC-SHA1"),
            URLQueryItem(name: "oauth_version", value: "1.0")
        ]
        
        if let token = token {
            authorizationHeaderQueryItems.append(URLQueryItem(name: "oauth_token", value: token))
        }
        
        for (key, value) in oauthItems {
            authorizationHeaderQueryItems.append(URLQueryItem(name: key, value: value))
        }
        
        let nonce = UUID().uuidString
        authorizationHeaderQueryItems.append(URLQueryItem(name: "oauth_nonce", value: nonce))
        
        let timestamp = String(Int(Date().timeIntervalSince1970))
        authorizationHeaderQueryItems.append(URLQueryItem(name: "oauth_timestamp", value: timestamp))
        
        let signature = try self.signature(queryItems: authorizationHeaderQueryItems + queryItems, HTTPMethod: HTTPMethod, url: url, consumerSecret: consumerSecret, tokenSecret: tokenSecret)
        authorizationHeaderQueryItems.append(URLQueryItem(name: "oauth_signature", value: signature))
        
        authorizationHeaderQueryItems.sort(by: {$0.name.compare($1.name) == .orderedAscending})
        
        var authorizationHeaderStringItems = [String]()
        
        for item in authorizationHeaderQueryItems {
            guard var authorizationHeaderString = item.name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUnreservedCharacters) else {
                break
            }
            if let value = item.value?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUnreservedCharacters) {
                authorizationHeaderString += "=\"\(value)\""
            }
            authorizationHeaderStringItems.append(authorizationHeaderString)
        }
        
        return "OAuth " + authorizationHeaderStringItems.joined(separator: ", ")
    }
    
    internal class func signature(queryItems: [URLQueryItem], HTTPMethod: String, url: URL, consumerSecret: String, tokenSecret: String?) throws -> String {
        let queryItems = queryItems.sorted(by: {$0.name.compare($1.name) == .orderedAscending})
        
        let signatureKey = "\(consumerSecret)&\(tokenSecret ?? "")"
        var signatureValue = "\(HTTPMethod)"
        if let path = url.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUnreservedCharacters) {
            signatureValue += "&\(path)"
        }
        else {
            throw Error.Unknown
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = queryItems
        if let percentEncodedQuery = urlComponents.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: CharacterSet.twitterAllowedCharacters)?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUnreservedCharacters) {
            signatureValue += "&\(percentEncodedQuery)"
        }
        
        let key = CryptoUtils.byteArray(from: signatureKey)
        let data : [UInt8] = CryptoUtils.byteArray(from: signatureValue)
        
        guard let hmac = HMAC(using: HMAC.Algorithm.sha1, key: key).update(byteArray: data)?.final() else {
            throw Error.Unknown
        }
        
        return (CryptoUtils.data(from: hmac) as Data).base64EncodedString()
    }
}
