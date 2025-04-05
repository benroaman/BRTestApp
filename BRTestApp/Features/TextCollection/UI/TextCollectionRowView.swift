//
//  TextCollectionRowView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import SwiftUI

struct TextCollectionRowView<M: TextCollectionRowViewModel>: View {
    let record: TextRecord
    let model: M
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
            FavoriteButton(isActive: record.isFavorite, callback: {
                model.onTextCollectionRowFavorite(record)
            })
        }
        .alert("Delete?", isPresented: $isShowingAlert, actions: {
            Button(role: .destructive, action: {
                withAnimation(.easeOut(duration: 0.3)) { model.onTextCollectionRowDelete(record) }
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
            Text("Are you sure you want to delete \"\(record.text)\"\(record.isFavorite ? " - it's one of your favorites!" : "?")")
        })
        .contextMenu {
            Button(action: {
                print("CONTEXT!")
            }, label: {
                Label("Some Action", systemImage: "heart.fill")
            })
        }
    }
}

protocol TextCollectionRowViewModel {
    func onTextCollectionRowDelete(_ record: TextRecord)
    func onTextCollectionRowFavorite(_ record: TextRecord)
}

#Preview {
    struct TestModel: TextCollectionRowViewModel {
        func isFavorite(_ record: TextRecord) -> Bool { true }
        func onTextCollectionRowDelete(_ record: TextRecord) { }
        func onTextCollectionRowFavorite(_ record: TextRecord) { }
    }
    
    return TextCollectionRowView(record: TextRecord("Testy McTestFace"), model: TestModel())
}

#Preview("Long") {
    struct TestModel: TextCollectionRowViewModel {
        func isFavorite(_ record: TextRecord) -> Bool { true }
        func onTextCollectionRowDelete(_ record: TextRecord) { }
        func onTextCollectionRowFavorite(_ record: TextRecord) { }
    }
    
    return TextCollectionRowView(record: TextRecord("Testy McTestFace Testy McTestFace Testy McTestFace Testy McTestFace Testy McTestFace Testy McTestFace"), model: TestModel())
}
