//
//  MovieDTO.swift
//  TCAEx
//
//  Created by Tom Choi on 2/10/26.
//

import Foundation

/// TMDB API 응답을 위한 DTO (Data Transfer Object)
/// - Domain Entity와 분리하여 API 스펙 변경에 대응
struct MovieSearchResponseDTO: Decodable {
    let results: [MovieDTO]
}

/// 영화 데이터 전송 객체
struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    /// DTO를 Domain Entity로 변환
    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage
        )
    }
}
