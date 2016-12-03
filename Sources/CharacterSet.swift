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
        var urlUnreservedCharacters = CharacterSet.alphanumerics
        urlUnreservedCharacters.insert(charactersIn: "-._~")
        return urlUnreservedCharacters
    }
}
