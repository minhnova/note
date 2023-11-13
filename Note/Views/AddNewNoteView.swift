//
//  SwiftUIView.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import SwiftUI
import SwiftData

struct AddNewNoteView: View {
    
    var viewModel: ViewModel
    
    @State var noteTitle: String = ""
    @State var noteDetail: String = ""
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(Date.now.formatted(.dateTime.hour().minute().day().month().year()))
                    .font(.caption)
            }
            TextField("Untitled", text: $noteTitle)
                .foregroundColor(Color.black)
                .font(.largeTitle)
                .bold()
            Divider()
            TextEditor(text: $noteDetail)
                .scrollContentBackground(.hidden)
                .background(Color.init(red: 244/255, green: 237/255, blue: 204/255))
        }
        .onDisappear(perform: {
            if !noteDetail.isEmpty {
                if noteTitle.isEmpty {
                    noteTitle = "Untitled"
                }
                let note = Note(title: noteTitle, detail: noteDetail, date: .now)
                modelContext.insert(note)
                try? modelContext.save()
                viewModel.notes.insert(note, at: 0)
            }
        })
        .navigationBarTitle("", displayMode: .inline)
        .padding()
        .background(Color.init(red: 244/255, green: 237/255, blue: 204/255))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)
    return AddNewNoteView(viewModel: ViewModel(modelContext: container.mainContext))
}
