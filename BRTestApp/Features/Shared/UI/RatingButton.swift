//
//  RatingButton.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/3/25.
//

import SwiftUI

struct RatingButton: View {
    @Binding var rating: Int
    @State var activating: Set<Int> = []
    private let animationDuration: TimeInterval = 0.275
    private let staggerTimeBase: TimeInterval = 0.12
    let color: Color
    let fillSymbol: String
    let emptySymbol: String
    
    init(rating: Binding<Int>, color: Color = .orange, fillSymbol: String = "star.fill", emptySymbol: String = "star") {
        self._rating = rating
        self.color = color
        self.fillSymbol = fillSymbol
        self.emptySymbol = emptySymbol
    }
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach((1..<6)) { index in
                Button(action: {
                    withAnimation(.linear(duration: animationDuration)) {
                        if index == rating {
                            rating = 0
                        } else if index < rating {
                            rating = index
                        } else {
                            var stagger: TimeInterval = 0
                            for i in 1...index {
                                let delay = stagger
                                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                    activating.insert(i)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                                        activating.remove(i)
                                    }
                                }
                                stagger += staggerTimeBase/TimeInterval(i*2)
                            }
                            rating = index
                        }
                    }
                }) {
                    Image(systemName: index <= rating ? fillSymbol : emptySymbol)
                }
                .foregroundStyle(color)
                .scaleEffect(activating.contains(index) ? 1.5 : 1)
                .animation(.easeInOut(duration: animationDuration), value: activating)
                .animation(.linear(duration: animationDuration), value: rating)
                .buttonStyle(.borderless)
            }
        }
    }
}

#Preview("Default") {
    struct Preview: View {
        @State var rating = 0
        var body: some View {
            RatingButton(rating: $rating)
        }
    }

    return Preview()
}

#Preview("Hearts") {
    struct Preview: View {
        @State var rating = 0
        var body: some View {
            RatingButton(rating: $rating, color: .red, fillSymbol: "heart.fill", emptySymbol: "heart")
        }
    }

    return Preview()
}
