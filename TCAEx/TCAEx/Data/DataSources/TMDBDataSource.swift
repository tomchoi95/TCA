//
//  TMDBDataSource.swift
//  TCAEx
//
//  Created by Tom Choi on 2/10/26.
//

import Foundation

/// TMDB API 데이터 소스
/// - 실제 API 호출 또는 Mock 데이터 제공
protocol TMDBDataSourceProtocol {
    func searchMovies(query: String) async throws -> [MovieDTO]
}

/// Mock 데이터 소스 (개발 및 테스트용)
struct MockTMDBDataSource: TMDBDataSourceProtocol {
    func searchMovies(query: String) async throws -> [MovieDTO] {
        // 네트워크 지연 시뮬레이션
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5초
        
        // Mock 데이터 반환
        return [
            MovieDTO(
                id: 1,
                title: "The Shawshank Redemption",
                overview: "두 남자가 감옥에서 우정을 쌓고 구원과 최종 해방을 찾는 이야기입니다.",
                posterPath: "/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
                releaseDate: "1994-09-23",
                voteAverage: 8.7
            ),
            MovieDTO(
                id: 2,
                title: "The Godfather",
                overview: "미국 범죄 가문의 노령 총수가 자신의 비밀 제국을 막내아들에게 넘기는 이야기입니다.",
                posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
                releaseDate: "1972-03-14",
                voteAverage: 8.7
            ),
            MovieDTO(
                id: 3,
                title: "The Dark Knight",
                overview: "배트맨이 고담시를 위협하는 조커라는 혼돈의 범죄자를 막기 위해 싸웁니다.",
                posterPath: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg",
                releaseDate: "2008-07-16",
                voteAverage: 8.5
            ),
            MovieDTO(
                id: 4,
                title: "Inception",
                overview: "꿈 속에서 아이디어를 훔치는 도둑이 마지막 임무로 아이디어를 심는 일을 맡습니다.",
                posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
                releaseDate: "2010-07-15",
                voteAverage: 8.4
            ),
            MovieDTO(
                id: 5,
                title: "Interstellar",
                overview: "우주 비행사 팀이 인류의 생존을 위해 웜홀을 통과하여 새로운 행성을 찾습니다.",
                posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
                releaseDate: "2014-11-05",
                voteAverage: 8.3
            )
        ].filter { $0.title.lowercased().contains(query.lowercased()) }
    }
}

/// 실제 TMDB API 데이터 소스
struct LiveTMDBDataSource: TMDBDataSourceProtocol {
    private let apiKey = "YOUR_API_KEY_HERE" // 나중에 환경 변수로 관리
    private let baseURL = "https://api.themoviedb.org/3"
    
    func searchMovies(query: String) async throws -> [MovieDTO] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(encodedQuery)&language=ko-KR"
        
        guard let url = URL(string: urlString) else {
            throw RepositoryError.networkError
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw RepositoryError.networkError
        }
        
        do {
            let searchResponse = try JSONDecoder().decode(MovieSearchResponseDTO.self, from: data)
            return searchResponse.results
        } catch {
            throw RepositoryError.decodingError
        }
    }
}
