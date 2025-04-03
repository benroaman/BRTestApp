//
//  TextCollectionRootView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import SwiftUI

struct TextCollectionRootView<S: TextCollectionState>: View {
    let state: S
    @State private var router = Router<TextCollectionRoute>("com.app.TextCollectionRouterState")
    
    var body: some View {
        NavigationStack(path: $router.path) {
            List(state.textCollection) { record in
                Button(action: {
                    router.push(.detail(record))
                }, label: {
                    TextCollectionRowView(record: record, isFavorite: state.favorites.contains(record.id), deleteCallback: {
                        state.removeRecord(record)
                    }, favoriteCallback: {
                        state.toggleFavorite(record)
                    })
                })
            }
            .navigationTitle("Text Collection")
            .toolbar {
                Button(action: {
                    router.push(.creation(TextModifyState()))
                }, label: {
                    Image(systemName: "plus").font(.headline)
                })
            }
            .navigationDestination(for: TextCollectionRoute.self) { getDestination(for: $0) }
        }
    }
    
    @ViewBuilder
    func getDestination(for route: TextCollectionRoute) -> some View {
        switch route {
        case .creation(let state): CreateTextRecordView(creation: state, collection: self.state, dismissCallback: { router.path.removeLast() })
        case .detail(let record): EmptyView()
        case .edit(let record): EmptyView()
        }
    }
}

#Preview("Actual") {
    TextCollectionRootView(state: TextCollectionStateActual())
}

#Preview("Empty") {
    TextCollectionRootView(state: TextCollectionStateMockEmpty())
}

#Preview("Single") {
    TextCollectionRootView(state: TextCollectionStateMockSingle())
}

#Preview("Many") {
    TextCollectionRootView(state: TextCollectionStateMockMany())
}
