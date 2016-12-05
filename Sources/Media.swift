//
//  Media.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

@objc(STWMedia)
public class Media: NSObject {
    
    static let extensionForType = [
        "image/jpeg": ".jpg",
        "image/png": ".png",
        "image/gif": ".gif",
        "image/tiff": ".tif"
    ]
    
    var jsonObject: [String:Any]
    
    @objc public var id: Int64
    
    class func mimeType(forImageData imageData: Data) -> String?
    {
        var c = [UInt8](repeating: 0, count: 1)
        imageData.copyBytes(to: &c, count: 1)
        
        let ext : String?
        
        switch (c[0]) {
        case 0xFF:
            ext = "image/jpeg"
        case 0x89:
            ext = "image/png"
        case 0x47:
            ext = "image/gif"
        case 0x49, 0x4D :
            ext = "image/tiff"
        default:
            ext = nil
        }
        
        return ext
    }
    
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
    
    @objc public func uploadPhotoMediaTask(photoData: Data, completionHandler: @escaping (Media?, Swift.Error?) -> Void) throws -> MediaSessionTask {
        let url = URL.twitterRESTAPIURL(endpoint: "media/upload.json")!
        
        let httpMethod = "POST"
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod
        
        let authorizationHeader = try OAuth.authorizationHeader(HTTPMethod: httpMethod, url: url, consumerKey: self.consumerKey, consumerSecret: self.consumerSecret, token: self.account?.oauthToken, tokenSecret: self.account?.oauthTokenSecret)
        urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        let multipartBoundary = "0xN0b0dy_lik3s_a_mim3__AKhSmhMrH"
        urlRequest.setValue("multipart/form-data; boundary=\(multipartBoundary)", forHTTPHeaderField: "Content-Type")
        
        let multiparts = [
        Multipart(data: photoData, name: "media", type: Media.mimeType(forImageData: photoData), filename: "file" + (Media.extensionForType[Media.mimeType(forImageData: photoData) ?? ""] ?? ""))
        ]
        
        urlRequest.httpBody = try MultipartSerialization.data(withMultiparts: multiparts, boundary: multipartBoundary)
        
        let urlSessionTask = self.urlSession.uploadTask(with: urlRequest, from: nil, completionHandler: { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            do {
                guard let data = data else {
                    completionHandler(nil, error)
                    return
                }
                
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                
                try TwitterError.checkTwitterError(onJsonObject: jsonObject)
                
                guard let media = Media(jsonObject: jsonObject) else {
                    completionHandler(nil, error)
                    return
                }
                
                completionHandler(media, nil)
            }
            catch let error {
                completionHandler(nil, error)
            }
        })
        
        let mediaSessionTask = MediaSessionTask(urlSessionTask: urlSessionTask)
        
        return mediaSessionTask
    }
}
