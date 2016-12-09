//
//  Multipart.swift
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
