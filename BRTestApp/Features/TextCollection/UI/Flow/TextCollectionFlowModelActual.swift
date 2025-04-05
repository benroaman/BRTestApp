//
//  TextCollectionFlowModelActual.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/4/25.
//

import Foundation

struct TextCollectionFlowModelActual<Collection: TextCollectionState>: TextCollectionFlowModel {
    
    // MARK: Instance Members
    let collectionState: Collection
    var router = Router<TextCollectionRoute>("com.app.textCollectionFlowNavPath")
    
    // MARK: Initializers
    init(collectionState: Collection) {
        self.collectionState = collectionState
    }
    
    /// TextCollectionListScreenModel
    var collection: [TextRecord] { collectionState.textCollection }
    func onTextCollectionListRowTapped(for record: TextRecord) { router.push(.detail(record)) }
    func onTextCollectionListCreateTapped() { router.push(.creation(TextModifyState())) }
    func onTextCollectionListRowMoved(from source: IndexSet, to destination: Int) { collectionState.moveRecords(from: source, to: destination) }
    
    /// TextCollectionRowViewModel
    func onTextCollectionRowDelete(_ record: TextRecord) {
        collectionState.removeRecord(record)
        router.popOne()
    }
    
    func onTextCollectionRowFavorite(_ record: TextRecord) { collectionState.toggleFavorite(record) }
}
