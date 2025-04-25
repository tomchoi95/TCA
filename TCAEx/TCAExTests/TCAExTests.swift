//
//  TCAExTests.swift
//  TCAExTests
//
//  Created by 최범수 on 2025-04-25.
//

import Testing
import ComposableArchitecture

@testable import TCAEx

@MainActor
struct TCAExTests {

    @Test func basics() async throws {
        let store = await TestStore(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() }
        )
        
        await store.send(.incrementButtonTapped) { $0.count = 1 }
        await store.send(.decrementButtonTapped) { $0.count = 0 }
    }

    @Test
      func timer() async {
        let clock = TestClock()


        let store = await TestStore(initialState: CounterFeature.State()) {
          CounterFeature()
        } withDependencies: {
          $0.continuousClock = clock
        }
        
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
}
