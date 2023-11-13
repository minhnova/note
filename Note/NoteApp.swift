//
//  NoteApp.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import SwiftUI
import SwiftData

@main
struct NoteApp: App {
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView(modelContext: container.mainContext)
        }
        .modelContainer(container)
    }
    
    init() {
        do {
            container = try ModelContainer(for: Note.self)
        } catch {
            fatalError("Failed to create ModelContainer for Note.")
        }
    }
}
