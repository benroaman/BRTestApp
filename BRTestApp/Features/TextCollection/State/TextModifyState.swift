//
//  TextModifyState.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/3/25.
//

import Foundation

// MARK: Base
@Observable
final class TextModifyState: Codable, Hashable {
    // MARK: Instance Members
    var newText: String
    var isFavorite: Bool
    let id: String
    let intent: Intent
    
    // MARK: Initializers
    init() {
        self.newText = ""
        self.isFavorite = false
        self.id = UUID().uuidString
        self.intent = .create
    }
    
    init(record: TextRecord, isFavorite: Bool) {
        self.newText = record.text
        self.isFavorite = isFavorite
        self.id = UUID().uuidString
        self.intent = .edit(record)
    }
        
    // MARK: Hashable Conformance
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: TextModifyState, rhs: TextModifyState) -> Bool { lhs.id == rhs.id }
}

extension TextModifyState {
    enum Intent: Hashable, Codable {
        case create, edit(TextRecord)
        
        var navTitle: String {
            switch self {
            case .create: return "Create Text"
            case .edit: return "Edit Text"
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .create: hasher.combine("create")
            case .edit(let record):
                hasher.combine("edit")
                hasher.combine(record.hashValue)
            }
        }
        
        static func ==(lhs: Intent, rhs: Intent) -> Bool {
            switch (lhs, rhs) {
            case (.create, .create): return true
            case (.edit(let lhsRecord), .edit(let rhsRecord)): return lhsRecord == rhsRecord
            default: return false
            }
        }
    }
}
