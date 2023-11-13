//
//  NoteDetailView.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import SwiftUI
import SwiftData

struct NoteDetailView: View {

    @Bindable var note: Note
    @State private var updated: Bool = false
    
    @Environment(\.modelContext) var modelContext
    @Environment(ViewModel.self) private var viewModel

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(note.date.formatted(.dateTime.hour().minute().day().month().year()))
                    .font(.caption)
            }
            TextField("Please add note title", text: $note.title)
                .foregroundColor(Color.black)
                .font(.largeTitle)
                .bold()
            Divider()
            TextEditor(text: $note.detail)
                .scrollContentBackground(.hidden)
                .background(Color.init(red: 244/255, green: 237/255, blue: 204/255))
            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .padding()
        .onChange(of: note.title, {
            updated = true
        })
        .onChange(of: note.detail) {
            updated = true
        }
        .onDisappear(perform: {
            updateDataModel()
        })
        .background(Color.init(red: 244/255, green: 237/255, blue: 204/255))
    }
    
    private func updateDataModel() {
        guard updated else {
            return
        }
        note.date = .now
        let indexOfEditedNote = viewModel.notes.firstIndex(of: note) ?? -1
        if indexOfEditedNote != -1 {
            viewModel.notes.remove(at: indexOfEditedNote)
            viewModel.notes.insert(note, at: 0)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)
    let note = Note(title: "Test destination")
    
    return NoteDetailView(note: note)
        .modelContainer(container)
}

