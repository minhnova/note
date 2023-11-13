//
//  Note.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import Foundation
import SwiftData

@Model
class Note: Identifiable, Hashable {
    @Attribute(.unique) let id: UUID = UUID()
    var title: String
    var detail: String
    var date: Date
    var bgColor: RGB
    
    init(title: String = "" , detail: String = "" , date: Date = .now, bgColor: RGB = .random()) {
        self.title = title
        self.detail = detail
        self.date = date
        self.bgColor = bgColor
    }
}

extension Note {
    static func predicate(
        searchText: String
    ) -> Predicate<Note> {
        return #Predicate<Note> { note in
            if searchText.isEmpty {
                return true
            } else {
                return note.title.localizedStandardContains(searchText) ||
                note.detail.localizedStandardContains(searchText)
            }
        }
    }
}

