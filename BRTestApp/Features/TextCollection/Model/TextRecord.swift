//
//  TextRecord.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import Foundation

// MARK: Base
struct TextRecord: Codable, Identifiable {
    var text: String
    let id: String
    
    init(_ text: String) {
        self.text = text
        self.id = UUID().uuidString
    }
}

// MARK: Equatable Conformance
extension TextRecord: Equatable {
    static func == (lhs: TextRecord, rhs: TextRecord) -> Bool { lhs.id == rhs.id }
}

// MARK: Hashable Conformance
extension TextRecord: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
