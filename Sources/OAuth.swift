//
//  OAuth.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation
import Cryptor

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    import Accounts
    import Social
#endif

/// A class for OAuth-ing with Twitter.
///
/// - note:
///     You can obtain Twitter OAuth Acess Token like this:
///
///         let session = Session(consumerKey: <#consumerKey#>, consumerSecret: <#consumerSecret#>)
///         OAuth.requestRequestToken(session: session, completionHandler: { (<#requestToken#>, <#requestTokenSecret#>, <#error#>) in
///             var urlComponents = URLComponents(url: OAuth.authorizeURL)
///             urlComponents.query = "oauth_token=\(<#requestToken#>)"
///
///             let authorizeURL = urlComponents.url
///
///             // Open authorizeURL on WebView or anything. and get OAuth verifier
///
///             OAuth.requestAccessToken(session: session, requestToken: <#requestToken#>, requestTokenSecret: <#requestTokenSecret#>, oauthVerifier: <#oauthVerifier#>, completionHandler: { (<#accessToken#>, <#accessTokenSecret#>, <#userID#>, <#screenName#>, <#error#>) in
///                 // Implementation
///             })
///         })
@objc(STWOAuth)
public class OAuth: NSObject {

    /// XAuth mode for OAuth requests.
    @objc(STWxAuthMode)
    public enum XAuthMode: UInt {
        /// None.
        case None = 0
        /// Client authentication based on Username, Password.
        case ClientAuth = 1
    }

    /// A URL for *authorize* endpoint. Desktop applications must use this endpoint.
    ///
    /// - seealso:
    ///     [Twitter Developer Documentation](https://dev.twitter.com/oauth/reference/get/oauth/authorize)
    public static var authorizeURL: URL {
        return URL.twitterOAuthURL(endpoint: "authorize")!
    }

    /// A URL for *authenticate* endpoint.
    ///
    /// - seealso:
    ///     [Twitter Developer Documentation](https://dev.twitter.com/oauth/reference/get/oauth/authenticate)
    public static var authenticateURL: URL {
        return URL.twitterOAuthURL(endpoint: "authenticate")!
    }

    /// Request Request-Token from Twitter OAuth 1.0a
    ///
    /// - Parameters:
    ///   - session: A session for request.
    ///   - callback: OAuth callback string. The value you specify here will be used as the URL a user is redirected to should they approve your application’s access to their account. Set this to `oob` for out-of-band pin mode. This is also how you specify custom callbacks for use in desktop/mobile applications.
    ///   - completionHandler: A handler that will be called after completion.
    ///   - requestToken: A request token that returned
    ///   - requestTokenSecret: A request secret token that returned
    ///   - error: A error that returned
    @objc public class func requestRequestToken(session: Session, callback: String = "oob", completionHandler: @escaping (_ requestToken: String?, _ requestTokenSecret: String?, _ error: Swift.Error?) -> Void) {
        let url = URL.twitterOAuthURL(endpoint: "request_token")!

        let httpMethod = "POST"

        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod

            let oauthItems = ["oauth_callback": callback]

            let authorizationHeader = try self.authorizationHeader(oauthItems: oauthItems, HTTPMethod: httpMethod, url: url, consumerKey: session.consumerKey, consumerSecret: session.consumerSecret, token: nil, tokenSecret: nil)
            urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")

            let task = session.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    completionHandler(nil, nil, error)
                    return
                }

                do {
                    let (token, tokenSecret, userInfo) = try self.processOAuth(response: response, data: data)

                    guard let callbackConfirmed = Bool((userInfo["oauth_callback_confirmed"] ?? nil) ?? "false"), callbackConfirmed == true else {
                        completionHandler(nil, nil, Error.Unknown)
                        return
                    }

                    completionHandler(token, tokenSecret, nil)
                } catch let error {
                    completionHandler(nil, nil, error)
                }
            })
            task.resume()
        } catch let error {
            completionHandler(nil, nil, error)
        }
    }

    /// Request Request-Token from Twitter OAuth 1.0a for Reverse Auth
    ///
    /// - Parameters:
    ///   - session: A session for request.
    ///   - completionHandler: A handler that will be called after completion.
    ///   - response: A string that returned for access token
    ///   - error: A error that returned
    @objc public class func requestRequestTokenForxAuthReverse(session: Session, completionHandler: @escaping (_ response: String?, _ error: Swift.Error?) -> Void) {
        let url = URL.twitterOAuthURL(endpoint: "request_token")!

        let httpMethod = "POST"

        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod

            let queryItems = [ URLQueryItem(name: "x_auth_mode", value: "reverse_auth") ]

            let authorizationHeader = try self.authorizationHeader(queryItems: queryItems, HTTPMethod: httpMethod, url: url, consumerKey: session.consumerKey, consumerSecret: session.consumerSecret, token: nil, tokenSecret: nil)
            urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")

            var urlComponents = URLComponents()
            urlComponents.queryItems = queryItems

            urlRequest.httpBody = urlComponents.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: CharacterSet.twitterAllowedCharacters)?.data(using: .utf8)

            let task = session.urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    completionHandler(nil, error)
                    return
                }

                guard let data = data else {
                    completionHandler(nil, error)
                    return
                }

                guard let responseString = String(data: data, encoding: .utf8) else {
                    completionHandler(nil, error)
                    return
                }

                do {
                    try TwitterError.checkTwitterError(onJsonObject: try? JSONSerialization.jsonObject(with: data, options: []))

                    completionHandler(responseString, nil)
                } catch let error {
                    completionHandler(nil, error)
                }
            })
            task.resume()
        } catch let error {
            completionHandler(nil, error)
        }
    }

    /// Request Access-Token Completion Handler
    ///
    /// - Parameters:
    ///   - accessToken: A access token that returned
    ///   - accessTokenSecret: A access secret token that returned
    ///   - userID: A user ID that returned
    ///   - screenName: A screen name that returned
    ///   - error: A error that returned
    public typealias RequestAccessTokenCompletionHandler = (_ accessToken: String?, _ accessTokenSecret: String?, _ userID: Int64, _ screenName: String?, _ error: Swift.Error?) -> Void

    /// Request Access-Token from Twitter OAuth 1.0a
    ///
    /// - Parameters:
    ///   - session: A session for request.
    ///   - requestToken: A request token.
    ///   - requestTokenSecret: A request token secret.
    ///   - xAuthMode: xAuth mode. For possible values, see xAuthMode.
    ///   - xAuthUsername: A username for xAuth ClientAuth.
    ///   - xAuthPassword: A password for xAuth ClientAuth.
    ///   - oauthVerifier: A verifier from oauth/authentication.
    ///   - completionHandler: A handler that will be called after completion.
    @objc public class func requestAccessToken(session: Session, requestToken: String, requestTokenSecret: String, xAuthMode: XAuthMode = .None, xAuthUsername: String? = nil, xAuthPassword: String? = nil, oauthVerifier: String? = nil, completionHandler: @escaping RequestAccessTokenCompletionHandler) {
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
                    completionHandler(nil, nil, -1, nil, error)
                    return
                }

                do {
                    let (token, tokenSecret, userInfo) = try self.processOAuth(response: response, data: data)

                    let userID: Int64 = Int64((userInfo["user_id"] ?? "") ?? "") ?? -1
                    let screenName = userInfo["screen_name"] ?? nil

                    completionHandler(token, tokenSecret, userID, screenName, nil)
                } catch let error {
                    completionHandler(nil, nil, -1, nil, error)
                }
            })
            task.resume()
        } catch let error {
            completionHandler(nil, nil, -1, nil, error)
        }
    }

    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    /// Request Access-Token from Twitter OAuth 1.0a
    ///
    /// - Parameters:
    ///   - session: A session for request.
    ///   - account: A account from ACAccountStore for request
    ///   - requestResponse: A request response.
    ///   - completionHandler: A handler that will be called after completion.
    @objc public class func requestAccessToken(session: Session, accountForxAuthReverse account: ACAccount, requestResponse: String, completionHandler: @escaping RequestAccessTokenCompletionHandler) {
        let url = URL.twitterOAuthURL(endpoint: "access_token")!

        let parameters = ["x_reverse_auth_target": session.consumerKey, "x_reverse_auth_parameters": requestResponse]

        guard let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .POST, url: url, parameters: parameters) else {
            completionHandler(nil, nil, -1, nil, Error.Unknown)
            return
        }
        request.account = account

        let task = session.urlSession.dataTask(with: request.preparedURLRequest(), completionHandler: { (data, response, error) in
            if let error = error {
                completionHandler(nil, nil, -1, nil, error)
                return
            }

            do {
                let (token, tokenSecret, userInfo) = try self.processOAuth(response: response, data: data)

                let userID: Int64 = Int64((userInfo["user_id"] ?? "") ?? "") ?? -1
                let screenName = userInfo["screen_name"] ?? nil

                completionHandler(token, tokenSecret, userID, screenName, nil)
            } catch let error {
                completionHandler(nil, nil, -1, nil, error)
            }
        })
        task.resume()
    }
    #endif

    internal class func processOAuth(response: URLResponse?, data: Data?) throws -> (token: String, tokenSecret: String, userInfo: [String:String?]) {
        try TwitterError.checkTwitterError(onJsonObject: try? JSONSerialization.jsonObject(with: data ?? Data(), options: []))

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
        urlComponents.query = queryString.removingPercentEncoding

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
        } else {
            throw Error.Unknown
        }

        var urlComponents = URLComponents()
        urlComponents.queryItems = queryItems
        if let percentEncodedQuery = urlComponents.percentEncodedQuery?.addingPercentEncoding(withAllowedCharacters: CharacterSet.twitterAllowedCharacters)?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUnreservedCharacters) {
            signatureValue += "&\(percentEncodedQuery)"
        }

        let key = CryptoUtils.byteArray(from: signatureKey)
        let data: [UInt8] = CryptoUtils.byteArray(from: signatureValue)

        guard let hmac = HMAC(using: HMAC.Algorithm.sha1, key: key).update(byteArray: data)?.final() else {
            throw Error.Unknown
        }

        return (CryptoUtils.data(from: hmac) as Data).base64EncodedString()
    }
}
