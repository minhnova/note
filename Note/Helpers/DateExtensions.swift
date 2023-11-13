//
//  DateExtensions.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import Foundation

extension Date {
    static func random(in range: Range<Date>) -> Date {
        Date(
            timeIntervalSinceNow: .random(
                in: range.lowerBound.timeIntervalSinceNow...range.upperBound.timeIntervalSinceNow
            )
        )
    }
}

