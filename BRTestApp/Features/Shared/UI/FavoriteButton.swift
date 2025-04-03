//
//  FavoriteButton.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import SwiftUI

struct FavoriteButton: View {
    let isActive: Bool
    let callback: () -> Void
    @State var isBecomingActive: Bool = false
    private let animationDuration: TimeInterval = 0.3
    
    var body: some View {
        Button(action: {
            withAnimation(.bouncy(duration: animationDuration)) {
                callback()
                
                if !isActive {
                    isBecomingActive = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                        self.isBecomingActive = false
                    }
                }
            }
        }, label: {
            Image(systemName: isActive ? "star.fill" : "star")
                .foregroundStyle(Color.indigo)
        })
        .scaleEffect(isBecomingActive ? 1.5 : 1)
        .animation(.linear(duration: animationDuration), value: isActive)
        .animation(.easeInOut(duration: animationDuration), value: isBecomingActive)
        .buttonStyle(.borderless)
    }
}

#Preview("True") {
    FavoriteButton(isActive: true, callback: { })
}

#Preview("False") {
    FavoriteButton(isActive: false, callback: { })
}
