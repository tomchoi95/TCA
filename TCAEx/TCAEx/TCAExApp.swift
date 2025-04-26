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
    
    static let store = Store(
        initialState: AppFeature.State(),
        reducer: { AppFeature()._printChanges() },
        withDependencies: { $0.numberFact = .liveValue }
    )
    
    var body: some Scene {
        WindowGroup {
            AppView(store: TCAExApp.store)
        }
    }
}
