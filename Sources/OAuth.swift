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
    
    public class func requestRequestTokenWith(consumerKey: String, consumerSecret: String, xAuthMode: xAuthMode? , handler: (String, String) -> Void) {
        
    }
    
    public class func requestAccessTokenWith(requestToken: String, requestTokenSecret: String, oAuthVerifier: String, handler: (String, String) -> Void) {
        
    }
    
    public class func generateOAuthSignature(queryItems: [URLQueryItem]?, HTTPMethod: String, url: URL, consumerSecret: String, tokenSecret: String?) throws -> String {
        let queryItems = queryItems?.sorted(by: {$0.name.compare($1.name) == .orderedAscending})
        
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
