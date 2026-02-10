//
//  SearchMoviesUseCase.swift
//  TCAEx
//
//  Created by Tom Choi on 2/10/26.
//

import Foundation

/// 영화 검색 비즈니스 로직을 캡슐화한 UseCase
/// - 검색어 유효성 검증
/// - Repository를 통한 데이터 조회
/// - 비즈니스 규칙 적용
struct SearchMoviesUseCase: Sendable {
    private let repository: MovieRepositoryInterface
    
    init(repository: MovieRepositoryInterface) {
        self.repository = repository
    }
    
    /// 영화 검색 실행
    /// - Parameter query: 검색어
    /// - Returns: 검색된 영화 목록
    /// - Throws: RepositoryError
    func execute(query: String) async throws -> [Movie] {
        // 비즈니스 규칙: 검색어 유효성 검증
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty else {
            throw RepositoryError.invalidQuery
        }
        
        guard trimmedQuery.count >= 2 else {
            throw RepositoryError.invalidQuery
        }
        
        // Repository를 통한 데이터 조회
        let movies = try await repository.searchMovies(query: trimmedQuery)
        
        // 비즈니스 규칙: 결과가 없으면 에러
        guard !movies.isEmpty else {
            throw RepositoryError.noResults
        }
        
        // 비즈니스 규칙: 평점 순으로 정렬
        return movies.sorted { $0.voteAverage > $1.voteAverage }
    }
}
