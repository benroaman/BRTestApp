//
//  TextCollectionListScreen.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/4/25.
//

import SwiftUI
import OrderedCollections

struct TextCollectionListScreen<M: TextCollectionListScreenModel>: View {
    let model: M
    
    var body: some View {
        List(model.collection) { record in
            Button(action: {
                model.onTextCollectionListRowTapped(for: record)
            }, label: {
                TextCollectionRowView(record: record, model: model)
            })
        }
        .navigationTitle("Text Collection")
        .toolbar {
            Button(action: model.onTextCollectionListCreateTapped, label: {
                Image(systemName: "plus").font(.headline)
            })
        }
    }
}

protocol TextCollectionListScreenModel: TextCollectionRowViewModel {
    var collection: OrderedSet<TextRecord> { get }
    func isFavorite(_ record: TextRecord) -> Bool
    func onTextCollectionListRowTapped(for record: TextRecord)
    func onTextCollectionListCreateTapped()
}

#Preview {
    struct TestModel: TextCollectionListScreenModel {
        func isFavorite(_ record: TextRecord) -> Bool { true }
        func onTextCollectionRowDelete(_ record: TextRecord) { }
        func onTextCollectionRowFavorite(_ record: TextRecord) { }
        let collection: OrderedSet<TextRecord> = []
        func onTextCollectionListRowTapped(for record: TextRecord) { }
        func onTextCollectionListCreateTapped() { }
    }
    
    return TextCollectionListScreen(model: TestModel())
}
