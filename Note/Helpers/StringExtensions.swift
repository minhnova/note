//
//  StringExtensions.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import Foundation

extension String {

    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 0 ..< length {
            let randomIndex = Int(arc4random_uniform(UInt32(letters.count)))
            let letter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
            randomString += String(letter)
        }
        return randomString
    }
}
