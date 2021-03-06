//
//  Session.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
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

@objc(STWSession)
public class Session: NSObject {

    @objc public var account: Account?

    @objc public var consumerKey: String
    @objc public var consumerSecret: String

    let sessionDispatchQueue: DispatchQueue
    let sessionOperationQueue: OperationQueue
    private(set) lazy var urlSession: URLSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: self.sessionOperationQueue)

    @objc public init(consumerKey: String, consumerSecret: String) {
        let sessionDispatchQueue = DispatchQueue(label: "STwitter.Session.DispatchQueue")

        let sessionOperationQueue = OperationQueue()
        sessionOperationQueue.name = "STwitter.Session.OperationQueue"
        sessionOperationQueue.underlyingQueue = sessionDispatchQueue

        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.sessionDispatchQueue = sessionDispatchQueue
        self.sessionOperationQueue = sessionOperationQueue

        super.init()
    }
}

extension Session: URLSessionDelegate {

}
