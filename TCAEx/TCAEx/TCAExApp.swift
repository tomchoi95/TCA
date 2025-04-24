//
//  TCAExApp.swift
//  TCAEx
//
//  Created by 최범수 on 2025-04-09.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAExApp: App {
    
    static let store: Store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: TCAExApp.store)
        }
    }
}
