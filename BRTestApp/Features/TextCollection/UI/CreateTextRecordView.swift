//
//  CreateTextRecordView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/3/25.
//

import SwiftUI

struct CreateTextRecordView<Collection: TextCollectionState>: View {
    @State var creation: TextModifyState
    let collection: Collection
    let dismissCallback: () -> Void
    
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
                        print(creation.isFavorite)
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
        .navigationTitle(Text("Create Text"))
        .toolbar{
            Button("Save") {
                collection.addText(creation.newText, asFavorite: creation.isFavorite)
                dismissCallback()
            }
        }
    }
}

#Preview {
    CreateTextRecordView(creation: TextModifyState(), collection: TextCollectionStateActual(), dismissCallback: { })
}
