//
//  AppRootView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import SwiftUI

struct AppRootView<TC: TextCollectionState>: View {
    let state: AppState<TC>
    @State private(set) var selectedTab: Tabs = .text
    
    enum Tabs { case text }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TextCollectionFlow<TextCollectionFlowModelActual>(state: state.textCollectionState)
                .tabItem { Label("Text", systemImage: "character.cursor.ibeam") }
                .tag(Tabs.text)
        }
    }
}

#Preview("Many") {
    AppRootView(state: AppState(textCollectionState: TextCollectionStateMockMany()))
}
