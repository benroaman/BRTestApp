//
//  TextSettings.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import Foundation
import BRSettings
import Combine

struct TextSettings {
    private init() { }
}

extension TextSettings {
    static func reset() {
        TextRecords.reset()
        Favorites.reset()
    }
}

extension TextSettings {
    struct TextRecords: BRSetting {
        private init() { }
        typealias Value = [TextRecord]
        static var key: String = "com.beebooapps.BRTestApp.app.TextSettings.TextRecords"
        static var initial: Value = []
        static var pub: CurrentValueSubject<[TextRecord], Never> = .init(current)
    }
    
    struct Favorites: BRSetting {
        private init() { }
        typealias Value = Set<String>
        static var key: String = "com.beebooapps.BRTestApp.app.TextSettings.Favorites"
        static var initial: Value = []
        static var pub: CurrentValueSubject<Value, Never> = .init(current)
    }
}
