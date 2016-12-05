//
//  MultipartSerialization.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 5..
//
//

import Foundation

class MultipartSerialization: NSObject {

    class func data(withMultiparts multiparts: [Multipart], boundary: String) throws -> Data {
        var data = Data()
        
        for multipart in multiparts {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            
            if let filename = multipart.filename {
                data.append("Content-Disposition: form-data; name=\"\(multipart.name)\"; filename=\"./\(filename)\"\r\n".data(using: .utf8)!)
                
            }
            else {
                data.append("Content-Disposition: form-data; name=\"\(multipart.name)\"\r\n".data(using: .utf8)!)
            }
            
            if let type = multipart.type {
                data.append("Content-Type: \(type)\r\n".data(using: .utf8)!)
            }
            
            data.append("\r\n".data(using: .utf8)!)
            data.append(multipart.data)
            data.append("\r\n".data(using: .utf8)!)
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return data
    }
}
