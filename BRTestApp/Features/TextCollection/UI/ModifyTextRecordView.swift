//
//  ModifyTextRecordView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/3/25.
//

import SwiftUI

struct ModifyTextRecordView<Collection: TextCollectionState>: View {
    @StateObject var modification: TextModifyState
    let collection: Collection
    let router: Router<TextCollectionRoute>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Create some new text")
            TextField("Text", text: $modification.newText).textFieldStyle(.roundedBorder)
            Spacer().frame(height: 20)
            Text("Should it be a favorite?")
            Spacer().frame(height: 8)
            HStack(alignment: .center) {
                FavoriteButton(isActive: modification.isFavorite, callback: {
                    withAnimation(.bouncy(duration: 0.6, extraBounce: 0.2)) {
                        modification.isFavorite.toggle()
                    }
                })
                Spacer().frame(width: 12)
                if modification.isFavorite {
                    Text("Favorite!")
                        .font(.subheadline)
                        .transition(.scale.combined(with: .blurReplace))
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle(Text(modification.intent.navTitle))
        .toolbar{
            Button("Save") {
                switch modification.intent {
                case .create:
                    collection.createRecord(modification)
                case .edit(let record):
                    collection.modifyRecord(modification)
                }
                router.popOne()
            }
        }
    }
}

#Preview {
    ModifyTextRecordView(modification: TextModifyState(), collection: TextCollectionStateUserDefaultsBacked(), router: Router(""))
}
