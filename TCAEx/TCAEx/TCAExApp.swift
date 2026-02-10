//
//  TCAExApp.swift
//  TCAEx
//
//  Created by 최범수 on 2025-04-09.
//

import ComposableArchitecture
import SwiftUI

@main
struct TCAExApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(
                store: Store(initialState: SearchFeature.State()) {
                    SearchFeature()
                }
            )
        }
    }
}
