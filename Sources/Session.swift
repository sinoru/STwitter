//
//  Session.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//
//

import Foundation

@objc(STWSession)
public class Session: NSObject {
    
    public var account: Account?
    
    public var consumerKey: String
    public var consumerSecret: String
    
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
