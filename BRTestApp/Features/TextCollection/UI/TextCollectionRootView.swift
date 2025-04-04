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
    @State private var isPresentingCreate = false
    
    var body: some View {
        NavigationStack(path: $router.path) {
//            List(state.textCollection) { record in
//                Button(action: {
//                    router.push(.detail(record))
//                }, label: {
//                    TextCollectionRowView(record: record, isFavorite: state.favorites.contains(record.id), deleteCallback: {
//                        state.removeRecord(record)
//                    }, favoriteCallback: {
//                        state.toggleFavorite(record)
//                    })
//                })
//            }
            List {
                Section(header: Text("Text")) {
                    ForEach(state.textCollection) { record in
                        Button(action: {
                            router.push(.detail(record))
                        }, label: {
                            TextCollectionRowView(record: record, isFavorite: state.favorites.contains(record.id), deleteCallback: {
                                state.removeRecord(record)
                            }, favoriteCallback: {
                                state.toggleFavorite(record)
                            })
                        }).contextMenu {
                            Button(action: {
                                print("Action")
                            }, label: {
                                Label("Do A Thing", systemImage: "snowflake")
                            })
                        }
                    }
                }
                
                ProgressView().frame(maxWidth: .infinity).tint(Color.pink)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Text Collection")
            .toolbar {
                Button(action: {
//                    isPresentingCreate = true
                    router.push(.creation(TextModifyState()))
                }, label: {
                    Image(systemName: "plus").font(.headline)
                })
            }
            .navigationDestination(for: TextCollectionRoute.self) { getDestination(for: $0) }
        }.sheet(isPresented: $isPresentingCreate, content:  {
            ModifyTextRecordView(creation: TextModifyState(), collection: self.state, router: router).presentationDetents([.medium])
        })
    }
    
    @ViewBuilder
    func getDestination(for route: TextCollectionRoute) -> some View {
        switch route {
        case .creation(let state): ModifyTextRecordView(creation: state, collection: self.state, router: router)
        case .detail(let record): TextRecordDetailView(record: record, isFavorite: state.favorites.contains(record.id), favoriteCallback: { state.toggleFavorite(record) }, editCallback: { router.push(.edit(record)) })
        case .edit(let record): ModifyTextRecordView(creation: TextModifyState(record: record, isFavorite: state.favorites.contains(record.id)), collection: self.state, router: router)
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
