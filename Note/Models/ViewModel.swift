//
//  ViewModel.swift
//  Note
//
//  Created by Phai Hoang on 02/11/2023.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class ViewModel {
    
    var sort: SortDescriptor<Note> = SortDescriptor(\Note.date, order: .reverse)
    var searchText: String = ""
    var modelContext: ModelContext
    var totalNotes: Int = 0
    var page = 0
    var searchPage = 0
    var notes = [Note]()
    var searchResult = [Note]()
    var firstTimeDataLoaded: Bool = false
    var hasMoreDataToLoad: Bool = false
    var hasMoreDataToSearch: Bool = false
    var noteToDelete: Note?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchData() {
        do {
            let fetchDescriptor = descriptor(searchText: searchText, page: page)
            let res = try modelContext.fetch(fetchDescriptor)
            
            hasMoreDataToLoad = res.isEmpty ? false : true
            if page != 0 {
                notes.append(contentsOf: res)
            } else {
                notes = res
            }
            firstTimeDataLoaded = true
        } catch {
            print("Fetch failed")
        }
    }
    
    private func refreshData() {
        do {
            var fetchDescriptor = descriptor(searchText: searchText, page: page)
            fetchDescriptor.fetchOffset = 0
            let pageNumber = searchResult.isEmpty ? searchPage : page
            fetchDescriptor.fetchLimit = pageNumber * Constants.fetchLimit
            let res = try modelContext.fetch(fetchDescriptor)
            
            if searchResult.isEmpty {
                notes = res
            } else {
                searchResult = res
            }
            
        } catch {
            print("Fetch failed")
        }
    }
    
    func fetchMoreData() {
        if !searchResult.isEmpty {
            searchPage += 1
            searchMoreData()
        } else {
            page += 1
            fetchData()
        }
    }
    
    func search(searchText: String) {
        searchPage = 0
        searchResult.removeAll()
        self.searchText = searchText
        do {
            let descriptor = descriptor(searchText: searchText, page: searchPage)
            searchResult = try modelContext.fetch(descriptor)
            hasMoreDataToSearch = searchResult.isEmpty ? false : true
        } catch {
            print("Fetch failed")
        }
    }
    
    func sortData() {
        switch sort.order {
        case .forward :
            notes.sort { $0.date.compare($1.date) == .orderedAscending }
        case .reverse:
            notes.sort { $0.date.compare($1.date) == .orderedDescending }
        }
    }
    
    func deleteNote() {
        guard let note = noteToDelete else { return }
        modelContext.delete(note)
        refreshData()
         // TODO: To test the performance of removing an item, which method would be more efficient: using below code or using "//refreshdata()"?
//        if let index = notes.firstIndex(of: note) {

//
//            notes.remove(at: index)
//        }
//        
//        if !searchResult.isEmpty, let index = searchResult.firstIndex(of: note) {
//            searchResult.remove(at: index)
//        }

    }
    
    private func searchMoreData() {
        self.searchText = searchText
        do {
            let descriptor = descriptor(searchText: searchText, page: searchPage)
            let res = try modelContext.fetch(descriptor)
            hasMoreDataToSearch = res.isEmpty ? false : true
            searchResult.append(contentsOf: res)
        } catch {
            print("Fetch failed")
        }
    }
    
    private func descriptor(searchText: String, page: Int) -> FetchDescriptor<Note> {
        let predicate = Note.predicate(searchText: searchText)
        var fetchDescriptor = FetchDescriptor<Note>(predicate: predicate, sortBy: [sort])
        fetchDescriptor.fetchOffset = page * Constants.fetchLimit
        fetchDescriptor.fetchLimit = Constants.fetchLimit
        return fetchDescriptor
    }
}

