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
    
    // MARK: Initializers
    init() {
        self.newText = ""
        self.isFavorite = false
        self.id = UUID().uuidString
    }
    
    init(newText: String, isFavorite: Bool) {
        self.newText = newText
        self.isFavorite = isFavorite
        self.id = UUID().uuidString
    }
        
    // MARK: Hashable Conformance
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: TextModifyState, rhs: TextModifyState) -> Bool { lhs.id == rhs.id }
}
