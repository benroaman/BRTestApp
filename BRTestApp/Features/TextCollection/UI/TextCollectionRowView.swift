//
//  TextCollectionRowView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import SwiftUI

struct TextCollectionRowView: View {
    let record: TextRecord
    let isFavorite: Bool
    let deleteCallback: () -> Void
    let favoriteCallback: () -> Void
    @State private(set) var isDeleting: Bool = false
    @State private(set) var isShowingAlert: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            Text(record.text)
                .font(.headline)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .foregroundStyle(isDeleting ? Color.red : Color.primary)
                .animation(.linear(duration: 0.3), value: isDeleting)
            Spacer()
            Button(action: {
                isDeleting = true
                isShowingAlert = true
            }, label: {
                Image(systemName: isDeleting ? "trash.fill" : "trash")
                    .foregroundStyle(Color.red)
            })
            .animation(.linear(duration: 0.3), value: isDeleting)
            .buttonStyle(.borderless)
            Spacer().frame(width: 8)
            FavoriteButton(isActive: isFavorite, callback: favoriteCallback)
        }
        .alert("Delete?", isPresented: $isShowingAlert, actions: {
            Button(role: .destructive, action: {
                withAnimation(.easeOut(duration: 0.3)) { deleteCallback() }
            }, label: {
                Text("Delete")
            })
            Button(role: .cancel, action: {
                withAnimation(.linear(duration: 0.3)) {
                    isDeleting = false
                }
            }, label: {
                Text("Cancel")
            })
        }, message: {
            Text("Are you sure you want to delete \"\(record.text)\"\(isFavorite ? " - it's one of your favorites!" : "?")")
        })
    }
}

#Preview {
    TextCollectionRowView(record: TextRecord("Testy McTestFace"), isFavorite: true, deleteCallback: { }, favoriteCallback: { })
}

#Preview("Long") {
    TextCollectionRowView(record: TextRecord("Testy McTestFace Testy McTestFace Testy McTestFace Testy McTestFace Testy McTestFace Testy McTestFace"), isFavorite: true, deleteCallback: { }, favoriteCallback: { })
}
