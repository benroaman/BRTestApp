//
//  AppState.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import Foundation

// MARK: Requirements
protocol AppState {
    associatedtype TextCollection: TextCollectionState
    var textCollectionState: TextCollection { get }
}

// MARK: Actual
final class AppStateActual: AppState {
    typealias TextCollection = TextCollectionStateActual
    let textCollectionState = TextCollection()
}

// MARK: Mocks
final class AppStateMockEmpty: AppState {
    typealias TextCollection = TextCollectionStateMockEmpty
    let textCollectionState = TextCollection()
}

final class AppStateMockSingle: AppState {
    typealias TextCollection = TextCollectionStateMockSingle
    let textCollectionState = TextCollection()
}

final class AppStateMockMany: AppState {
    typealias TextCollection = TextCollectionStateMockMany
    let textCollectionState = TextCollection()
}
