//
//  MultipartSerialization.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 5..
//  Copyright © 2016 Sinoru. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation

class MultipartSerialization: NSObject {

    class func data(withMultiparts multiparts: [Multipart], boundary: String) throws -> Data {
        var data = Data()

        for multipart in multiparts {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)

            if let filename = multipart.filename {
                data.append("Content-Disposition: form-data; name=\"\(multipart.name)\"; filename=\"./\(filename)\"\r\n".data(using: .utf8)!)

            } else {
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
