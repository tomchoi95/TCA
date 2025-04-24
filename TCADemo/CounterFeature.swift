//
//  CountFeature.swift
//  TCADemo
//
//  Created by 최범수 on 2025-04-24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var count: Int = 0
    }
    
    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .incrementButtonTapped:
                    state.count += 1
                    return .none
                    
                case .decrementButtonTapped:
                    state.count -= 1
                    return .none
            }
        }
    }
}
