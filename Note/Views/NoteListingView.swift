//
//  NoteListingView.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import SwiftUI
import SwiftData

struct NoteListingView: View {
    
    var viewModel: ViewModel
    
    private var columns: [GridItem] {
        if UIDevice.current.userInterfaceIdiom == .pad {
            [GridItem(.adaptive(minimum: 400)),
             GridItem(.adaptive(minimum: 400))]
        } else {
            [GridItem(.adaptive(minimum: 300))]
        }
    }
    
    @State private var showingAlert = false
    
    @Environment(\.isSearching) var isSearching
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(isSearching ? viewModel.searchResult : viewModel.notes, id: \.id) { note in
                    NavigationLink(destination: NoteDetailView(note: note), label: {
                        NoteView(note: note, onComplete: {
                            showingAlert = true
                        })
                    })
                }
                .listRowSeparator(.hidden)
                
                if shouldLoadMoreData || shouldLoadMoreSearchData {
                    ProgressView("Loading more notes...")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .task {
                            viewModel.fetchMoreData()
                        }
                }
                if (viewModel.searchResult.isEmpty && isSearching && !viewModel.searchText.isEmpty) {
                    Text("No results!")
                }
                
                if (viewModel.searchResult.isEmpty && isSearching && viewModel.searchText.isEmpty) {
                    Text("You can search by note's title or detail")
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this note?"),
                    message: Text("There is no undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteNote()
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear(perform: {
                if !isSearching {
                    viewModel.searchResult.removeAll()
                }
                if !viewModel.firstTimeDataLoaded {
                    viewModel.fetchData()
                }
            })
            .navigationTitle("note")
            .overlay {
                if viewModel.notes.isEmpty {
                    ContentUnavailableView("No notes yet!", systemImage: "note")
                }
            }
        }
        .padding()
    }
    
    private var shouldLoadMoreData: Bool {
        return viewModel.hasMoreDataToLoad && !isSearching && !viewModel.notes.isEmpty
    }
    
    private var shouldLoadMoreSearchData: Bool {
        return viewModel.hasMoreDataToSearch && isSearching && !viewModel.searchText.isEmpty && !viewModel.searchResult.isEmpty
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Note.self, configurations: config)
    return NoteListingView(viewModel: ViewModel(modelContext: container.mainContext))
}
