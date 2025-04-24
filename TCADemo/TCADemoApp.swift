//
//  TCADemoApp.swift
//  TCADemo
//
//  Created by 최범수 on 2025-04-24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCADemoApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: TCADemoApp.store)
        }
    }
}
