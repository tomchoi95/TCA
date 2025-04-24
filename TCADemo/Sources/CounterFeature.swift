//
//  CounterFeature.swift
//
//
//  Created by 최범수 on 2025-04-24.
//
import Foundation
import ComposableArchitecture

@Reducer
public struct CounterFeature {
    @ObservableState
    public struct State: Equatable {
        public var count: Int = 0
        public var isLoading: Bool = false
        public var text: String = ""
        public var timmerIsRunning: Bool = false
    }
    
    public enum Action {
        case incrementButtonDidTap
        case decrementButtonDidTap
        case fetchButtonDidTap
        case fetchResponse(Result<String, Error>)
        case timmerToggleButtonDidTap
        case timerTick
    }
    
    enum CancelId { case timer }
    
    @Dependency(\.continuousClock) var clock
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .incrementButtonDidTap:
                    state.isLoading = false
                    state.text = ""
                    state.count += 1
                    return .none
                    
                case .decrementButtonDidTap:
                    state.isLoading = false
                    state.text = ""
                    state.count -= 1
                    return .none
                    
                case .fetchButtonDidTap:
                    state.isLoading = true
                    state.text = ""
                    return .run { [count = state.count] send in
                        guard let url = URL(string: "http://numbersapi.com/\(count)") else { return await send(.fetchResponse(.failure(URLError(.badURL)))) }
                        let (data, _) = try await URLSession.shared.data(from: url)
                        // response로 사용자에게 피드백 제대로 주기.
                        guard let text = String(data: data, encoding: .utf8) else { return await send(.fetchResponse(.failure(URLError(.cannotDecodeContentData))))}
                        return await send(.fetchResponse(.success(text)))
                    }
                    
                case .fetchResponse(let result):
                    state.text = ""
                    switch result {
                        case .success(let text):
                            state.text = text
                        case .failure(let error):
                            state.text = error.localizedDescription
                    }
                    state.isLoading = false
                    return .none
                    
                case .timmerToggleButtonDidTap:
                    state.timmerIsRunning.toggle()
                    if state.timmerIsRunning {
                        return .run { send in
                            for await _ in self.clock.timer(interval: .seconds(1)) {
                                await send(.timerTick)
                            }
                        }
                        .cancellable(id: CancelId.timer)
                    } else {
                        return .cancel(id: CancelId.timer)
                    }
                                        
                case .timerTick:
                    state.text = ""
                    state.count += 1
                    return .none
            }
        }
    }
}
