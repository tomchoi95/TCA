//
//  AppFeatureTests.swift
//  TCAExTests
//
//  Created by 최범수 on 2025-04-26.
//

import Testing
import ComposableArchitecture

@testable import TCAEx

@MainActor
struct AppFeatureTests {
    
    @Test func incrementInFirstTab() async throws {
        let store = TestStore(
            initialState: AppFeature.State(),
            reducer: { AppFeature() }
        )
        
        await store.send(.tab1(.incrementButtonTapped)) {
            $0.tab1.count = 1
        }
    }
}
