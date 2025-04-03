//
//  Router.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/3/25.
//

import Foundation
import UIKit

// References
// https://developer.apple.com/documentation/swiftui/navigationpath
// https://www.youtube.com/watch?v=GpjTeGPgIs8

@Observable
final class Router<R: Hashable & Codable> {
    // MARK: Private Constants
    private let peristenceKey: String
    
    // MARK: Public Variables
    var path: [R]
    
    // MARK: Initializers
    init(_ peristenceKey: String) {
        if let savedPathData = UserDefaults.standard.data(forKey: peristenceKey), let savedPath = try? JSONDecoder().decode([R].self, from: savedPathData) {
            self.path = savedPath
        } else {
            self.path = []
        }
        self.peristenceKey = peristenceKey
        
        NotificationCenter.default.addObserver(self, selector: #selector(savePath), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(savePath), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    // MARK: Private API
    @objc private func savePath() {
        if let data = try? JSONEncoder().encode(path) {
            UserDefaults.standard.set(data, forKey: peristenceKey)
        } else {
            UserDefaults.standard.set(Data(), forKey: peristenceKey)
        }
    }
}

// MARK: Public API
extension Router {
    func push(_ route: R) { path.append(route) }
    func popOne() {  path.removeLast() }
    func popToRoot() { path = [] }
    
    func removeLast(of route: R) {
        guard let lastIndex = path.lastIndex(of: route) else { return }
        path.remove(at: lastIndex)
    }
    
    func removeFirst(of route: R) {
        guard let firstIndex = path.firstIndex(of: route) else { return }
        path.remove(at: firstIndex)
    }
    
    func removeAll(of route: R) {
        path = path.filter({ $0 != route })
    }
}
