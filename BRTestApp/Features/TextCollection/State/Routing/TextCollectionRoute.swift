//
//  TextCollectionRoute.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/3/25.
//

import Foundation

// MARK: Base
enum TextCollectionRoute: Codable {
    case detail(TextRecord), creation(TextModifyState), edit(TextRecord)
}

// MARK: Hashable Implementation
extension TextCollectionRoute: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .detail(let record):
            hasher.combine("detail")
            hasher.combine(record.hashValue)
        case .creation(let state):
            hasher.combine("creation")
            hasher.combine(state.hashValue)
        case .edit(let record):
            hasher.combine("edit")
            hasher.combine(record.hashValue)
        }
    }
    
    static func == (lhs: TextCollectionRoute, rhs: TextCollectionRoute) -> Bool {
        switch (lhs, rhs) {
        case (.detail(let lhsRecord), .detail(let rhsRecord)):
            return lhsRecord == rhsRecord
        case (.creation(let lhsState), .creation(let rhsState)):
            return lhsState.id == rhsState.id
        case (.edit(let lhsRecord), .edit(let rhsRecord)):
            return lhsRecord == rhsRecord
        default: return false
        }
    }
}
