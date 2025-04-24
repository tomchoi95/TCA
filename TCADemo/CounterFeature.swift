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
        var isLoading: Bool = false
        var fact: String? = nil
        var isTimerRunning: Bool = false
    }
    
    enum Action {
        case incrementButtonTapped
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case toggleTimerButtonTapped
        case timerTick
    }
    
    enum CancelID { case timer }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .incrementButtonTapped:
                    state.count += 1
                    state.fact = nil
                    
                    return .none
                    
                case .decrementButtonTapped:
                    state.count -= 1
                    state.fact = nil
                    
                    return .none
                    
                case .factButtonTapped:
                    state.fact = nil
                    state.isLoading = true
                    
                    return .run { [count = state.count] send in
                        let url = URL(string: "http://numbersapi.com/\(count)")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let fact = String(decoding: data, as: UTF8.self)
                        
                        await send(.factResponse(fact))
                    }
                    
                case .factResponse(let fact):
                    state.fact = fact
                    state.isLoading = false
                    
                    return .none
                    
                case .toggleTimerButtonTapped:
                    state.isTimerRunning.toggle()
                    if state.isTimerRunning {
                        
                        // 이부분 이해 안감.
                        return .run { send in
                            while true {
                                try await Task.sleep(for: .seconds(1))
                                
                                await send(.timerTick)
                            }
                        }
                        .cancellable(id: CancelID.timer)
                        
                    } else {
                        
                        return .cancel(id: CancelID.timer)
                    }
                    
                case .timerTick:
                    state.count += 1
                    state.fact = nil
                    
                    return .none
            }
        }
    }
}
