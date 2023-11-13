//
//  ContentView.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var searchText = ""
    @State private var viewModel: ViewModel
    
    @Environment(\.modelContext) var modelContext
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            NoteListingView(viewModel: viewModel)
            
                .navigationTitle("Note")
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode:.always))
                .onChange(of: searchText, { _, newValue in
                    if newValue.isEmpty {
                        viewModel.searchResult.removeAll()
                        viewModel.searchText = ""
                    } else {
                        viewModel.search(searchText: newValue)
                    }
                    
                })
                .onChange(of: viewModel.sort, { _, _ in
                    viewModel.sortData()
                })
                .toolbar {
                    NavigationLink {
                        AddNewNoteView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "plus")
                    }

                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $viewModel.sort) {
                            Text("Newest First")
                                .tag(SortDescriptor(\Note.date, order: .reverse))
                            
                            Text("Oldest First")
                                .tag(SortDescriptor(\Note.date, order: .forward))
                        }
                        .pickerStyle(.inline)
                    }
                }
        }
        .environment(viewModel)
    }
    
//    private func addSamples() {
//        let today = Date.now
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let expiryMonth = "2022-01-10"
//        let oldMonth = dateFormatter.date(from: expiryMonth)
//        let range = (oldMonth ?? today)..<today
//        for _ in 1...100 {
//            let phai = Note(title: String.random(length: 8), date: Date.random(in: range))
//            print(phai.id)
//            modelContext.insert(phai)
//        }
//        try? modelContext.save()
//    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)
    return ContentView(modelContext: container.mainContext)
}
