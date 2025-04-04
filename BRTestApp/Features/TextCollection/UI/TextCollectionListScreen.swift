////
////  TextCollectionListScreen.swift
////  BRTestApp
////
////  Created by Ben Roaman on 4/4/25.
////
//
//import SwiftUI
//
//struct TextCollectionListScreen<M: TextCollectionListScreenModel>: View {
//    let model: M
//    
//    var body: some View {
//        List(model.collection.textCollection) { record in
//            Button(action: {
//                router.push(.detail(record))
//            }, label: {
//                TextCollectionRowView(record: record, isFavorite: state.favorites.contains(record.id), deleteCallback: {
//                    state.removeRecord(record)
//                }, favoriteCallback: {
//                    state.toggleFavorite(record)
//                })
//            })
//        }
//        .navigationTitle("Text Collection")
//        .toolbar {
//            Button(action: {
////                    isPresentingCreate = true
//                router.push(.creation(TextModifyState()))
//            }, label: {
//                Image(systemName: "plus").font(.headline)
//            })
//        }
//    }
//}
//
//protocol TextCollectionListScreenModel {
//    associatedtype Collection: TextCollectionState
//    var collection: Collection { get }
//    associatedtype Route: Hashable & Codable
//    var router: Router<Route> { get }
//}
//
//#Preview {
//    TextCollectionListScreen()
//}
