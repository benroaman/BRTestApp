//
//  AppRootView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import SwiftUI

struct AppRootView<S: AppState>: View {
    let state: S
    @State private(set) var selectedTab: Tabs = .text
    
    enum Tabs { case text }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TextCollectionRootView(state: state.textCollectionState)
                .tabItem { Label("Text", systemImage: "character.cursor.ibeam") }
                .tag(Tabs.text)
        }
    }
}

#Preview("Many") {
    AppRootView(state: AppStateMockMany())
}
