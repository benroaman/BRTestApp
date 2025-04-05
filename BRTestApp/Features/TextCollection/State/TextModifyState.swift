//
//  TextModifyState.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/3/25.
//

import Foundation

// MARK: Base
final class TextModifyState: Codable, Hashable, ObservableObject {
    // MARK: Instance Members
    @Published var newText: String
    @Published var isFavorite: Bool
    let id: String
    let intent: Intent
    
    // MARK: Initializers
    init() {
        self.newText = ""
        self.isFavorite = false
        self.id = UUID().uuidString
        self.intent = .create
    }
    
    init(record: TextRecord) {
        self.newText = record.text
        self.isFavorite = record.isFavorite
        self.id = UUID().uuidString
        self.intent = .edit(record)
    }
    
    func applyEdit() {
        switch intent {
        case .create: return
        case .edit(let record):
            record.text = newText
            record.isFavorite = isFavorite
        }
    }
        
    // MARK: Hashable Conformance
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: TextModifyState, rhs: TextModifyState) -> Bool { lhs.id == rhs.id }
    
    // MARK: Codable Conformance
    private enum CodingKeys: String, CodingKey {
        case newText, isFavorite, id, intent
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.newText = try container.decode(String.self, forKey: .newText)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.id = try container.decode(String.self, forKey: .id)
        self.intent = try container.decode(Intent.self, forKey: .intent)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(newText, forKey: .newText)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(id, forKey: .id)
        try container.encode(intent, forKey: .intent)
    }
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
