//
//  MovieDetailFeature.swift
//  TCAEx
//
//  Created by Tom Choi on 2/10/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct MovieDetailFeature {
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        let movie: Movie
    }
    
    // MARK: - Action
    enum Action {
        case onAppear
    }
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 필요시 추가 데이터 로드 등의 로직 추가 가능
                return .none
            }
        }
    }
}
