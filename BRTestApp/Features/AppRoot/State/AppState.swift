//
//  AppState.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import Foundation

final class AppState<TC: TextCollectionState> {
    let textCollectionState: TC
    
    init(textCollectionState: TC) {
        self.textCollectionState = textCollectionState
    }
}
