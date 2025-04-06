//
//  AppState.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import Foundation
import UIKit

final class AppState<TC: TextCollectionState> {
    let textCollectionState: TC
    
    let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    let isPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone
    
    let portraitWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    let portraitHeight: CGFloat = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    
    init(textCollectionState: TC) {
        self.textCollectionState = textCollectionState
    }
}
