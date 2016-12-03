//
//  Account.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 2..
//  Copyright © 2016년 Sinoru. All rights reserved.
//

import Foundation

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    @objc(STWAccount)
    public class Account: NSObject {
        
    }
#elseif os(Linux)
    public class Account {
        
    }
#endif

extension Account {
    
}
