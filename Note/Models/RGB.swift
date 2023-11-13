//
//  RGB.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import Foundation

struct RGB: Codable  {
    var red = 0.5
    var green = 0.5
    var blue = 0.5

    static func random() -> RGB {
        var rgb = RGB()
        rgb.red = Double.random(in: 0..<1)
        rgb.green = Double.random(in: 0..<1)
        rgb.blue = Double.random(in: 0..<1)
        return rgb
    }
}

