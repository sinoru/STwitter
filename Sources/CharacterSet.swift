//
//  CharacterSet.swift
//  STwitter
//
//  Created by Sinoru on 2016. 12. 3..
//
//

import Foundation

extension CharacterSet {
    static var urlUnreservedCharacters: CharacterSet {
        return CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
    }
}
