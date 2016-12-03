//
//  User.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 4..
//
//

import Cocoa

@objc(STWUser)
public class User: NSObject {
    
    var jsonObject: [String:Any]
    
    public var id: Int64
    public var screenName: String
    public var name: String? {
        return self.jsonObject["name"] as? String
    }
    public var profileImageURL: URL? {
        return URL(string: self.jsonObject["profile_image_url"] as? String ?? "")
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
        
        guard let screenName = jsonObject["screen_name"] as? String else {
            return nil
        }
        self.screenName = screenName
        
        super.init()
    }
}
