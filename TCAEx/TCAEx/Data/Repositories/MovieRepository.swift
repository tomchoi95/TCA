//
//  MovieRepository.swift
//  TCAEx
//
//  Created by Tom Choi on 2/10/26.
//

import Foundation

/// MovieRepositoryInterface의 구현체
/// - DataSource를 사용하여 데이터를 가져오고 Domain Entity로 변환
struct MovieRepository: MovieRepositoryInterface, Sendable {
    private let dataSource: TMDBDataSourceProtocol
    
    init(dataSource: TMDBDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        let dtos = try await dataSource.searchMovies(query: query)
        return dtos.map { $0.toDomain() }
    }
}
