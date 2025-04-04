//
//  AppRootView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import SwiftUI

struct AppRootView<S: AppState>: View {
    @State var state: S
    
    var body: some View {
        TabView(selection: $state.selectedTab) {
            TextCollectionRootView(state: state.textCollectionState)
                .tabItem { Label("Text", systemImage: "character.cursor.ibeam") }
                .tag(AppTabs.text)
            Text("Numbers")
                .tabItem { Label("Numbers", systemImage: "number") }
                .tag(AppTabs.number)
        }
    }
}

#Preview("Many") {
    AppRootView(state: AppStateMockMany())
}
