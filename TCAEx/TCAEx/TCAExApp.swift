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
        initialState: CounterFeature.State(),
        reducer: { CounterFeature() }
    )
    
    var body: some Scene {
        WindowGroup {
            CounterView(store: TCAExApp.store)
        }
    }
}
