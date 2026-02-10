//
//  MovieRepositoryInterface.swift
//  TCAEx
//
//  Created by Tom Choi on 2/10/26.
//

import Foundation

/// 영화 데이터 접근을 위한 Repository 인터페이스
/// - Domain Layer는 이 인터페이스에만 의존하며, 구현체는 알지 못함
/// - 클린 아키텍처의 의존성 역전 원칙(DIP) 적용
protocol MovieRepositoryInterface: Sendable {
    /// 영화 검색
    /// - Parameter query: 검색어
    /// - Returns: 검색된 영화 목록
    /// - Throws: 네트워크 에러 또는 파싱 에러
    func searchMovies(query: String) async throws -> [Movie]
}

/// Repository 에러 정의
enum RepositoryError: Error, Equatable {
    case networkError
    case decodingError
    case invalidQuery
    case noResults
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "네트워크 연결을 확인해주세요."
        case .decodingError:
            return "데이터 처리 중 오류가 발생했습니다."
        case .invalidQuery:
            return "검색어를 입력해주세요."
        case .noResults:
            return "검색 결과가 없습니다."
        }
    }
}
