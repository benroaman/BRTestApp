//
//  BRTestAppApp.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/3/25.
//

import SwiftUI

@main
struct SUITestApp: App {
    let state = AppState(textCollectionState: TextCollectionStateUserDefaultsBacked())
    
    var body: some Scene {
        WindowGroup {
            AppRootView(state: state)
        }
    }
}
