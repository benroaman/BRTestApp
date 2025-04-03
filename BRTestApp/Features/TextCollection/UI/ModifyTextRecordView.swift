//
//  ModifyTextRecordView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/3/25.
//

import SwiftUI

struct ModifyTextRecordView<Collection: TextCollectionState>: View {
    @State var creation: TextModifyState
    let collection: Collection
    let router: Router<TextCollectionRoute>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Create some new text")
            TextField("Text", text: $creation.newText).textFieldStyle(.roundedBorder)
            Spacer().frame(height: 20)
            Text("Should it be a favorite?")
            Spacer().frame(height: 8)
            HStack(alignment: .center) {
                FavoriteButton(isActive: creation.isFavorite, callback: {
                    withAnimation(.bouncy(duration: 0.6, extraBounce: 0.2)) {
                        creation.isFavorite.toggle()
                    }
                })
                Spacer().frame(width: 12)
                if creation.isFavorite {
                    Text("Favorite!")
                        .font(.subheadline)
                        .transition(.scale.combined(with: .blurReplace))
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle(Text(creation.intent.navTitle))
        .toolbar{
            Button("Save") {
                switch creation.intent {
                case .create:
                    collection.createRecord(creation.newText, asFavorite: creation.isFavorite)
                case .edit(let record):
                    collection.editRecord(record, with: creation.newText, asFavorite: creation.isFavorite)
                }
                router.popOne()
            }
        }
    }
}

#Preview {
    ModifyTextRecordView(creation: TextModifyState(), collection: TextCollectionStateActual(), router: Router(""))
}
