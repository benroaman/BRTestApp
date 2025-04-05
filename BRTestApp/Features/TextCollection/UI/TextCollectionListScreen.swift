//
//  TextCollectionListScreen.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/4/25.
//

import SwiftUI

struct TextCollectionListScreen<M: TextCollectionListScreenModel>: View {
    let model: M
    @State private var isEditing = false
    
    var body: some View {
        List {
            ForEach(model.collection) { record in
                Button(action: {
                    model.onTextCollectionListRowTapped(for: record)
                }, label: {
                    TextCollectionRowView(record: record, model: model)
                })
            }.onMove(perform: model.onTextCollectionListRowMoved)
        }
        .navigationTitle("Text Collection")
        .toolbar {
            EditButton()
            Button(action: model.onTextCollectionListCreateTapped, label: {
                Image(systemName: "plus").font(.headline)
            })
        }
    }
}

protocol TextCollectionListScreenModel: TextCollectionRowViewModel {
    var collection: [TextRecord] { get }
    func onTextCollectionListRowTapped(for record: TextRecord)
    func onTextCollectionListCreateTapped()
    func onTextCollectionListRowMoved(from source: IndexSet, to destination: Int)
}

#Preview {
    struct TestModel: TextCollectionListScreenModel {
        func isFavorite(_ record: TextRecord) -> Bool { true }
        func onTextCollectionRowDelete(_ record: TextRecord) { }
        func onTextCollectionRowFavorite(_ record: TextRecord) { }
        let collection: [TextRecord] = [TextRecord("Righteous Gemstones")]
        func onTextCollectionListRowTapped(for record: TextRecord) { }
        func onTextCollectionListCreateTapped() { }
        func onTextCollectionListRowMoved(from source: IndexSet, to destination: Int) { }
    }
    
    return TextCollectionListScreen(model: TestModel())
}
