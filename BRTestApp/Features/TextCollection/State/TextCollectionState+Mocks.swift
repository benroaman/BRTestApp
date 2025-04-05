//
//  TextCollectionState+Mocks.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/4/25.
//

import Foundation

// MARK: Mocks
@Observable
final class TextCollectionStateMockEmpty: TextCollectionState {
    private(set) var textCollection: [TextRecord] = []
    
    func createRecord(_ modification: TextModifyState) {
        let newRecord = TextRecord(modification.newText, isFavorite: modification.isFavorite)
        textCollection.append(newRecord)
    }
    
    func modifyRecord(_ modification: TextModifyState) {
        modification.applyEdit()
    }
    
    func removeRecord(_ record: TextRecord) {
        guard let index = textCollection.firstIndex(of: record) else { return }
        textCollection.remove(at: index)
    }
    
    func toggleFavorite(_ record: TextRecord) {
        record.isFavorite.toggle()
    }
    
    func moveRecords(from source: IndexSet, to destination: Int) {
        textCollection.move(fromOffsets: source, toOffset: destination)
    }
}

@Observable
final class TextCollectionStateMockSingle: TextCollectionState {
    private(set) var textCollection: [TextRecord] = [TextRecord("Cheers!")]
    
    func createRecord(_ modification: TextModifyState) {
        let newRecord = TextRecord(modification.newText, isFavorite: modification.isFavorite)
        textCollection.append(newRecord)
    }
    
    func modifyRecord(_ modification: TextModifyState) {
        modification.applyEdit()
    }
    
    func removeRecord(_ record: TextRecord) {
        guard let index = textCollection.firstIndex(of: record) else { return }
        textCollection.remove(at: index)
    }
    
    func toggleFavorite(_ record: TextRecord) {
        record.isFavorite.toggle()
    }
    
    func moveRecords(from source: IndexSet, to destination: Int) {
        textCollection.move(fromOffsets: source, toOffset: destination)
    }
}

@Observable
final class TextCollectionStateMockMany: TextCollectionState {
    private(set) var textCollection: [TextRecord] = [TextRecord("Parks & Rec"), TextRecord("Community"), TextRecord("Happy Endings"), TextRecord("Schitt's Creek")]
    
    func createRecord(_ modification: TextModifyState) {
        let newRecord = TextRecord(modification.newText, isFavorite: modification.isFavorite)
        textCollection.append(newRecord)
    }
    
    func modifyRecord(_ modification: TextModifyState) {
        modification.applyEdit()
    }
    
    func removeRecord(_ record: TextRecord) {
        guard let index = textCollection.firstIndex(of: record) else { return }
        textCollection.remove(at: index)
    }
    
    func toggleFavorite(_ record: TextRecord) {
        record.isFavorite.toggle()
    }
    
    func moveRecords(from source: IndexSet, to destination: Int) {
        textCollection.move(fromOffsets: source, toOffset: destination)
    }
}
