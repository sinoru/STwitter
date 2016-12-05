//
//  SessionTask.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 4..
//
//

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
