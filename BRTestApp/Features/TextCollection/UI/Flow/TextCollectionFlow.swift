//
//  TextCollectionFlow.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import SwiftUI

struct TextCollectionFlow<M: TextCollectionFlowModel>: View {
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
        case .creation(let state): ModifyTextRecordView(modification: state, collection: model.collectionState, router: model.router)
        case .detail(let record): TextRecordDetailView(record: record, favoriteCallback: { model.collectionState.toggleFavorite(record) }, editCallback: { model.router.push(.edit(record)) })
        case .edit(let record): ModifyTextRecordView(modification: TextModifyState(record: record), collection: model.collectionState, router: model.router)
        }
    }
}

protocol TextCollectionFlowModel: TextCollectionListScreenModel {
    associatedtype Collection: TextCollectionState
    var collectionState: Collection { get }
    var router: Router<TextCollectionRoute> { get set }
    init(collectionState: Collection)
}

#Preview("Actual") {
    TextCollectionFlow<TextCollectionFlowModelActual>(state: TextCollectionStateUserDefaultsBacked())
}
