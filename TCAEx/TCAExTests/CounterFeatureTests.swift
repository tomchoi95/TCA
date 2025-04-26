//
//  CounterFeatureTests.swift
//  CounterFeatureTests
//
//  Created by 최범수 on 2025-04-25.
//

import Testing
import ComposableArchitecture

@testable import TCAEx

@MainActor
struct CounterFeatureTests {
    
    @Test func basics() async throws {
        let store = TestStore(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() }
        )
        
        await store.send(.incrementButtonTapped) { $0.count = 1 }
        await store.send(.decrementButtonTapped) { $0.count = 0 }
    }
    
    @Test func timer() async {
        let clock = TestClock()
        let store = TestStore(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() },
            withDependencies: { $0.continuousClock = clock }
        )
        
        await store.send(.timerToggleButtonTapped) {
            $0.isTimerRunning = true
        }
        await clock.advance(by: .seconds(1))
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        await store.send(.timerToggleButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
    @Test func numberFact() async throws {
        let store = TestStore(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() }
        )
        
        await store.send(.factButtonTapped) { $0.isLoading = true }
        await store.receive(\.factResponse, timeout: .seconds(1)) {
              $0.isLoading = false
              $0.fact = "???"
            }
    }
}
