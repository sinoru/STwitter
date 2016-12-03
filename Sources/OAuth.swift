//
//  OAuth.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation
import Cryptor

public class OAuth: NSObject {
    public enum xAuthMode {
        case ClientAuth
        case ReverseAuth
    }
    
    public class func requestRequestToken(session: Session, xAuthMode: xAuthMode?, callback: String, handler: @escaping (String?, String?, NSError?) -> Void) {
        guard let url = URL.twitterOAuthURL(endpoint: "request_token") else {
            handler(nil, nil, Error.unknown)
            return
        }
        
        let httpMethod = "POST"
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod
            
            var oauthItems = ["oauth_callback": callback]
            
            let authorizationHeader = try self.authorizationHeader(oauthItems: oauthItems, HTTPMethod: httpMethod, url: url, consumerKey: session.consumerKey, consumerSecret: session.consumerSecret)
            
            urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
            
            let task = session.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    handler(nil, nil, error as NSError?)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, 200 <= response.statusCode && response.statusCode < 300 else {
                    handler(nil, nil, Error.unknown)
                    return
                }
                
                guard let data = data else {
                    handler(nil, nil, Error.unknown)
                    return
                }
                
                guard let queryString = String(data: data, encoding: .utf8) else {
                    handler(nil, nil, Error.unknown)
                    return
                }
                
                var urlComponents = URLComponents()
                urlComponents.percentEncodedQuery = queryString
                
                guard let queryItems = urlComponents.queryItems else {
                    handler(nil, nil, Error.unknown)
                    return
                }
                
                guard let token = queryItems.filter({$0.name == "oauth_token"}).last?.value else {
                    handler(nil, nil, Error.unknown)
                    return
                }
                
                guard let tokenSecret = queryItems.filter({$0.name == "oauth_token_secret"}).last?.value else {
                    handler(nil, nil, Error.unknown)
                    return
                }
                
                handler(token, tokenSecret, nil)
            })
            task.resume()
        }
        catch let error as NSError {
            handler(nil, nil, error)
        }
        catch {
            handler(nil, nil, Error.unknown)
        }
    }
    
    public class func requestAccessToken(requestToken: String, requestTokenSecret: String, oAuthVerifier: String, handler: (String, String) -> Void) {
        
    }
    
    internal class func authorizationHeader(queryItems: [URLQueryItem] = [], oauthItems: [String:String] = [:], HTTPMethod: String, url: URL, consumerKey: String, consumerSecret: String, token: String? = nil, tokenSecret: String? = nil) throws -> String {
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
            throw Error.unknown
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = queryItems
        var rePercentEncodingAllowedCharacters = CharacterSet.urlUnreservedCharacters
        rePercentEncodingAllowedCharacters.insert(charactersIn: "%&=")
        if let percentEncodedQuery = urlComponents.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: rePercentEncodingAllowedCharacters)?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUnreservedCharacters) {
            signatureValue += "&\(percentEncodedQuery)"
        }
        
        let key = CryptoUtils.byteArray(from: signatureKey)
        let data : [UInt8] = CryptoUtils.byteArray(from: signatureValue)
        
        guard let hmac = HMAC(using: HMAC.Algorithm.sha1, key: key).update(byteArray: data)?.final() else {
            throw Error.unknown
        }
        
        return (CryptoUtils.data(from: hmac) as Data).base64EncodedString()
    }
}
