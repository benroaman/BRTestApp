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
                .padding(12)
                .background(Color.indigo.opacity(0.2))
                .containerShape(RoundedRectangle(cornerRadius: 12))
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .visualEffect { content, proxy in
                    content
                        .hueRotation(Angle(degrees: proxy.frame(in: .global).origin.y/6))
                        .blur(radius: Self.getBlurForProxy(proxy))
                }
            }.onMove(perform: model.onTextCollectionListRowMoved)
        }
        .listStyle(.plain)
        .listRowSpacing(4)
//        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .navigationTitle("Text Collection")
        .toolbar {
            EditButton()
            Button(action: model.onTextCollectionListCreateTapped, label: {
                Image(systemName: "plus").font(.headline)
            })
        }
    }
    
    nonisolated static func getBlurForProxy(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .global).minY
        print(minY)
        if minY < 0 {
            return abs(minY)/10
        } else {
            return 0
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
        let collection: [TextRecord] = [TextRecord("Righteous Gemstones"),
                                        TextRecord("Brooklyn 99"),
                                        TextRecord("Righteous Gemstones"),
                                        TextRecord("Brooklyn 99"),
                                        TextRecord("Righteous Gemstones"),
                                        TextRecord("Brooklyn 99"),
                                        TextRecord("Righteous Gemstones"),
                                        TextRecord("Brooklyn 99")
                                        ]
        func onTextCollectionListRowTapped(for record: TextRecord) { }
        func onTextCollectionListCreateTapped() { }
        func onTextCollectionListRowMoved(from source: IndexSet, to destination: Int) { }
    }
    
    return TextCollectionListScreen(model: TestModel())
}
