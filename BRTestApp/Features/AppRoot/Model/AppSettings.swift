//
//  AppSettings.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/4/25.
//

import Foundation
import BRSettings
import Combine

struct AppSettings {
    private init() { }
}

extension AppSettings {
    static func reset() {
        SelectedTab.reset()
    }
}

extension AppSettings {
    struct SelectedTab: BRSetting {
        private init() { }
        typealias Value = AppTabs
        static var key: String = "com.beebooapps.BRTestApp.app.AppSettings.SelectedTab"
        static var initial: Value = .text
        static var pub: CurrentValueSubject<Value, Never> = .init(current)
    }
}
