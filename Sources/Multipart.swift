//
//  Multipart.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 5..
//
//

import Foundation

class Multipart: NSObject {

    let name: String
    let type: String?
    let filename: String?
    let data: Data
    
    init(data: Data, name: String, type: String?, filename: String?) {
        self.data = data
        self.name = name
        self.type = type
        self.filename = filename
        super.init()
    }
}
