//
//  TextState.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import Foundation

// MARK: Protocol
protocol TextCollectionState: Observable {
    var textCollection: [TextRecord] { get }
    func createRecord(_ modification: TextModifyState)
    func modifyRecord(_ modification: TextModifyState)
    func removeRecord(_ record: TextRecord)
    func toggleFavorite(_ record: TextRecord)
    func moveRecords(from source: IndexSet, to destination: Int)
}

// MARK: Actual
@Observable
final class TextCollectionStateUserDefaultsBacked: TextCollectionState {
    // MARK: Instance Variables
    private(set) var textCollection: [TextRecord]
    
    // MARK: Initializers
    init() {
        self.textCollection = TextSettings.TextRecords.current
    }
    
    // MARK: Public API
    func createRecord(_ modification: TextModifyState) {
        let newRecord = TextRecord(modification.newText, isFavorite: modification.isFavorite)
        textCollection.append(newRecord)
        TextSettings.TextRecords.set(Array(textCollection))
    }
    
    func modifyRecord(_ modification: TextModifyState) {
        modification.applyEdit()
        TextSettings.TextRecords.set(Array(textCollection))
    }
    
    func removeRecord(_ record: TextRecord) {
        guard let index = textCollection.firstIndex(of: record) else { return }
        textCollection.remove(at: index)
        TextSettings.TextRecords.set(textCollection)
    }
    
    func toggleFavorite(_ record: TextRecord) {
        record.isFavorite.toggle()
        TextSettings.TextRecords.set(textCollection)
    }
    
    func moveRecords(from source: IndexSet, to destination: Int) {
        textCollection.move(fromOffsets: source, toOffset: destination)
        TextSettings.TextRecords.set(textCollection)
    }
}

// MARK: Actual
@Observable
final class TextCollectionStateCoreDataBacked: TextCollectionState {
    // MARK: Instance Variables
    private(set) var textCollection: [TextRecord]
    
    // MARK: Initializers
    init() {
        self.textCollection = TextSettings.TextRecords.current
    }
    
    // MARK: Public API
    func createRecord(_ modification: TextModifyState) {
        let newRecord = TextRecord(modification.newText, isFavorite: modification.isFavorite)
        textCollection.append(newRecord)
        TextSettings.TextRecords.set(Array(textCollection))
    }
    
    func modifyRecord(_ modification: TextModifyState) {
        modification.applyEdit()
        TextSettings.TextRecords.set(Array(textCollection))
    }
    
    func removeRecord(_ record: TextRecord) {
        guard let index = textCollection.firstIndex(of: record) else { return }
        textCollection.remove(at: index)
        TextSettings.TextRecords.set(textCollection)
    }
    
    func toggleFavorite(_ record: TextRecord) {
        record.isFavorite.toggle()
        TextSettings.TextRecords.set(textCollection)
    }
    
    func moveRecords(from source: IndexSet, to destination: Int) {
        textCollection.move(fromOffsets: source, toOffset: destination)
        TextSettings.TextRecords.set(textCollection)
    }
}
