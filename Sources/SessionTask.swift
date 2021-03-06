//
//  SessionTask.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 4..
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

@objc(STWSessionTask)
public class SessionTask: NSObject {

    private let urlSessionTask: URLSessionTask
    @objc init(urlSessionTask: URLSessionTask) {
        self.urlSessionTask = urlSessionTask
        super.init()
    }

    @objc public func resume() {
        self.urlSessionTask.resume()
    }
}
