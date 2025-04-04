//
//  TextCollectionRootView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import SwiftUI
import OrderedCollections

struct TextCollectionRootView<M: TextCollectionFlowModel>: View {
    @State private var model: M

    init(state: M.Collection) {
        self.model = M(collectionState: state)
    }
    
    var body: some View {
        NavigationStack(path: $model.router.path) {
            TextCollectionListScreen(model: model)
            .navigationDestination(for: TextCollectionRoute.self) { getDestination(for: $0) }
        }
    }
    
    @ViewBuilder
    func getDestination(for route: TextCollectionRoute) -> some View {
        switch route {
        case .creation(let state): ModifyTextRecordView(creation: state, collection: model.collectionState, router: model.router)
        case .detail(let record): TextRecordDetailView(record: record, isFavorite: model.collectionState.favorites.contains(record.id), favoriteCallback: { model.collectionState.toggleFavorite(record) }, editCallback: { model.router.push(.edit(record)) })
        case .edit(let record): ModifyTextRecordView(creation: TextModifyState(record: record, isFavorite: model.collectionState.favorites.contains(record.id)), collection: model.collectionState, router: model.router)
        }
    }
}

protocol TextCollectionFlowModel: TextCollectionListScreenModel {
    associatedtype Collection: TextCollectionState
    var collectionState: Collection { get }
    var router: Router<TextCollectionRoute> { get set }
    init(collectionState: Collection)
}

struct TextCollectionFlowModelActual<Collection: TextCollectionState>: TextCollectionFlowModel {
    init(collectionState: Collection) {
        self.collectionState = collectionState
    }
    
    let collectionState: Collection
    var router = Router<TextCollectionRoute>("com.app.textCollectionFlowNavPath")
    
    var collection: OrderedSet<TextRecord> { collectionState.textCollection }
    
    func isFavorite(_ record: TextRecord) -> Bool {
        collectionState.favorites.contains(record.id)
    }
    
    func onTextCollectionListRowTapped(for record: TextRecord) {
        router.push(.detail(record))
    }
    
    func onTextCollectionListCreateTapped() {
        router.push(.creation(TextModifyState()))
    }
    
    func onTextCollectionRowDelete(_ record: TextRecord) {
        collectionState.removeRecord(record)
        router.popOne()
    }
    
    func onTextCollectionRowFavorite(_ record: TextRecord) {
        collectionState.toggleFavorite(record)
    }
}

#Preview("Actual") {
    TextCollectionRootView<TextCollectionFlowModelActual>(state: TextCollectionStateActual())
}
