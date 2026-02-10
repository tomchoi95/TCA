//
//  SearchFeature.swift
//  TCAEx
//
//  Created by Tom Choi on 2/10/26.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SearchFeature {
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var searchQuery = ""
        var movies: [Movie] = []
        var isLoading = false
        var errorMessage: String?
        
        // 네비게이션을 위한 선택된 영화
        @Presents var destination: Destination.State?
    }
    
    // MARK: - Action
    enum Action {
        case searchQueryChanged(String)
        case searchResponse(Result<[Movie], Error>)
        case movieTapped(Movie)
        case destination(PresentationAction<Destination.Action>)
    }
    
    // MARK: - Destination (네비게이션)
    @Reducer
    struct Destination {
        @ObservableState
        enum State: Equatable {
            case detail(MovieDetailFeature.State)
        }
        
        enum Action {
            case detail(MovieDetailFeature.Action)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: \.detail, action: \.detail) {
                MovieDetailFeature()
            }
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.searchMoviesUseCase) var searchMoviesUseCase
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .searchQueryChanged(query):
                state.searchQuery = query
                state.errorMessage = nil
                
                // 검색어가 비어있으면 결과 초기화
                guard !query.isEmpty else {
                    state.movies = []
                    state.isLoading = false
                    return .cancel(id: CancelID.search)
                }
                
                // 로딩 상태 시작
                state.isLoading = true
                
                // Debounce: 0.5초 후 검색 실행
                return .run { send in
                    try await Task.sleep(for: .milliseconds(500))
                    
                    do {
                        let movies = try await searchMoviesUseCase.execute(query: query)
                        await send(.searchResponse(.success(movies)))
                    } catch {
                        await send(.searchResponse(.failure(error)))
                    }
                }
                .cancellable(id: CancelID.search, cancelInFlight: true)
                
            case let .searchResponse(.success(movies)):
                state.isLoading = false
                state.movies = movies
                state.errorMessage = nil
                return .none
                
            case let .searchResponse(.failure(error)):
                state.isLoading = false
                state.movies = []
                
                if let repoError = error as? RepositoryError {
                    state.errorMessage = repoError.localizedDescription
                } else {
                    state.errorMessage = "알 수 없는 오류가 발생했습니다."
                }
                return .none
                
            case let .movieTapped(movie):
                state.destination = .detail(MovieDetailFeature.State(movie: movie))
                return .none
                
            case .destination:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination) {
            Destination()
        }
    }
    
    // MARK: - Cancel ID
    enum CancelID {
        case search
    }
}

// MARK: - Dependency
extension SearchMoviesUseCase: DependencyKey {
    public static let liveValue = SearchMoviesUseCase(
        repository: MovieRepository(
            dataSource: MockTMDBDataSource() // Mock 데이터 사용
        )
    )
    
    public static let testValue = SearchMoviesUseCase(
        repository: MovieRepository(
            dataSource: MockTMDBDataSource()
        )
    )
}

extension DependencyValues {
    var searchMoviesUseCase: SearchMoviesUseCase {
        get { self[SearchMoviesUseCase.self] }
        set { self[SearchMoviesUseCase.self] = newValue }
    }
}
