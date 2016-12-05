//
//  SessionTask.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 4..
//
//

import Foundation

public class SessionTask: NSObject {

    private let urlSessionTask: URLSessionTask
    init(urlSessionTask: URLSessionTask) {
        self.urlSessionTask = urlSessionTask
        super.init()
    }
    
    public func resume() {
        self.urlSessionTask.resume()
    }
}
