//
//  AppState.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import Foundation
import UIKit

// MARK: Requirements
protocol AppState {
    associatedtype TextCollection: TextCollectionState
    var textCollectionState: TextCollection { get }
    var selectedTab: AppTabs { get set }
}

// MARK: Actual
final class AppStateActual: AppState {
    typealias TextCollection = TextCollectionStateActual
    let textCollectionState = TextCollection()
    var selectedTab = AppTabs.text
    
    init() {
        selectedTab = AppSettings.SelectedTab.current
        
        NotificationCenter.default.addObserver(self, selector: #selector(storeSelectedTab), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(storeSelectedTab), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc private func storeSelectedTab() {
        AppSettings.SelectedTab.set(selectedTab)
    }
}

// MARK: Mocks
final class AppStateMockEmpty: AppState {
    typealias TextCollection = TextCollectionStateMockEmpty
    let textCollectionState = TextCollection()
    var selectedTab = AppTabs.text
}

final class AppStateMockSingle: AppState {
    typealias TextCollection = TextCollectionStateMockSingle
    let textCollectionState = TextCollection()
    var selectedTab = AppTabs.text
}

final class AppStateMockMany: AppState {
    typealias TextCollection = TextCollectionStateMockMany
    let textCollectionState = TextCollection()
    var selectedTab = AppTabs.text
}
