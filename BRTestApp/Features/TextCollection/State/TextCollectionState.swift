//
//  TextState.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import Foundation
import OrderedCollections

// MARK: Protocol
protocol TextCollectionState: Observable {
    var textCollection: OrderedSet<TextRecord> { get }
    var favorites: Set<String> { get }
    func createRecord(_ text: String, asFavorite: Bool)
    func editRecord(_ record: TextRecord, with newText: String, asFavorite: Bool)
    func removeRecord(_ record: TextRecord)
    func toggleFavorite(_ record: TextRecord)
}

// MARK: Actual
@Observable
final class TextCollectionStateActual: TextCollectionState {
    // MARK: Instance Variables
    private(set) var textCollection: OrderedSet<TextRecord>
    private(set) var favorites: Set<String>
    
    // MARK: Initializers
    init() {
        self.textCollection = OrderedSet(TextSettings.TextRecords.current)
        self.favorites = TextSettings.Favorites.current
    }
    
    // MARK: Public API
    func createRecord(_ text: String, asFavorite: Bool) {
        let newRecord = TextRecord(text)
        textCollection.append(newRecord)
        TextSettings.TextRecords.set(Array(textCollection))
        if asFavorite { toggleFavorite(newRecord) }
    }
    
    func editRecord(_ record: TextRecord, with newText: String, asFavorite: Bool) {
        let edited = record.replacingText(with: newText)
        textCollection.updateOrInsert(edited, at: textCollection.count)
        TextSettings.TextRecords.set(Array(textCollection))
        
        guard asFavorite != favorites.contains(edited.id) else { return }
        
        if asFavorite {
            favorites.insert(edited.id)
            TextSettings.Favorites.insert(edited.id)
        } else {
            favorites.remove(edited.id)
            TextSettings.Favorites.remove(edited.id)
        }
    }
    
    func removeRecord(_ record: TextRecord) {
        textCollection.remove(record)
        TextSettings.TextRecords.set(Array(textCollection))
        favorites.remove(record.id)
        TextSettings.Favorites.remove(record.id)
    }
    
    func toggleFavorite(_ record: TextRecord) {
        if favorites.contains(record.id) {
            favorites.remove(record.id)
            TextSettings.Favorites.remove(record.id)
        } else {
            favorites.insert(record.id)
            TextSettings.Favorites.insert(record.id)
        }
    }
}

// MARK: Mocks
@Observable
final class TextCollectionStateMockEmpty: TextCollectionState {
    private(set) var textCollection: OrderedSet<TextRecord> = []
    private(set) var favorites: Set<String> = []

    func createRecord(_ text: String, asFavorite: Bool) {
        let newRecord = TextRecord(text)
        textCollection.append(newRecord)
        if asFavorite { toggleFavorite(newRecord) }
    }
    
    func editRecord(_ record: TextRecord, with newText: String, asFavorite: Bool) {
        let edited = record.replacingText(with: newText)
        textCollection.updateOrInsert(edited, at: textCollection.count)
        
        guard asFavorite != favorites.contains(edited.id) else { return }
        
        if asFavorite {
            favorites.insert(edited.id)
        } else {
            favorites.remove(edited.id)
        }
    }
    
    func removeRecord(_ record: TextRecord) {
        textCollection.remove(record)
        favorites.remove(record.id)
    }
    
    func toggleFavorite(_ record: TextRecord) {
        if favorites.contains(record.id) {
            favorites.remove(record.id)
        } else {
            favorites.insert(record.id)
        }
    }
}

@Observable
final class TextCollectionStateMockSingle: TextCollectionState {
    private(set) var textCollection: OrderedSet<TextRecord> = [TextRecord("Cheers!")]
    private(set) var favorites: Set<String> = []

    func createRecord(_ text: String, asFavorite: Bool) {
        let newRecord = TextRecord(text)
        textCollection.append(newRecord)
        if asFavorite { toggleFavorite(newRecord) }
    }

    func editRecord(_ record: TextRecord, with newText: String, asFavorite: Bool) {
        let edited = record.replacingText(with: newText)
        textCollection.updateOrInsert(edited, at: textCollection.count)
        
        guard asFavorite != favorites.contains(edited.id) else { return }
        
        if asFavorite {
            favorites.insert(edited.id)
        } else {
            favorites.remove(edited.id)
        }
    }
    
    func removeRecord(_ record: TextRecord) {
        textCollection.remove(record)
        favorites.remove(record.id)
    }

    func toggleFavorite(_ record: TextRecord) {
        if favorites.contains(record.id) {
            favorites.remove(record.id)
        } else {
            favorites.insert(record.id)
        }
    }
}

@Observable
final class TextCollectionStateMockMany: TextCollectionState {
    private(set) var textCollection: OrderedSet<TextRecord> = [TextRecord("Parks & Rec"), TextRecord("Community"), TextRecord("Happy Endings"), TextRecord("Schitt's Creek")]
    private(set) var favorites: Set<String> = []

    func createRecord(_ text: String, asFavorite: Bool) {
        let newRecord = TextRecord(text)
        textCollection.append(newRecord)
        TextSettings.TextRecords.set(Array(textCollection))
        if asFavorite { toggleFavorite(newRecord) }
    }
    
    func editRecord(_ record: TextRecord, with newText: String, asFavorite: Bool) {
        let edited = record.replacingText(with: newText)
        textCollection.updateOrInsert(edited, at: textCollection.count)
        
        guard asFavorite != favorites.contains(edited.id) else { return }
        
        if asFavorite {
            favorites.insert(edited.id)
        } else {
            favorites.remove(edited.id)
        }
    }
    
    func removeRecord(_ record: TextRecord) {
        textCollection.remove(record)
        favorites.remove(record.id)
    }
    
    func toggleFavorite(_ record: TextRecord) {
        if favorites.contains(record.id) {
            favorites.remove(record.id)
        } else {
            favorites.insert(record.id)
        }
    }
}
