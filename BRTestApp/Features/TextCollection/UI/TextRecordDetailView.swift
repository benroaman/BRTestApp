//
//  TextRecordDetailView.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/3/25.
//

import SwiftUI

struct TextRecordDetailView: View {
    let record: TextRecord
    let isFavorite: Bool
    let favoriteCallback: () -> Void
    let editCallback: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(record.text)
            Spacer()
        }
        .navigationTitle("Detail")
        .toolbar {
            FavoriteButton(isActive: isFavorite, callback: favoriteCallback)
            Spacer().frame(width: 12)
            Button(action: {
                editCallback()
            }, label: {
                Image(systemName: "pencil")
            })
        }
    }
}

#Preview {
    TextRecordDetailView(record: TextRecord("Test"), isFavorite: false, favoriteCallback: { }, editCallback: { })
}
