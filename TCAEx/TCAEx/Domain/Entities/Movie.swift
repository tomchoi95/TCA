//
//  Movie.swift
//  TCAEx
//
//  Created by Tom Choi on 2/10/26.
//

import Foundation

/// 영화 도메인 엔티티
/// - 순수 비즈니스 모델로 외부 프레임워크 의존성 없음
struct Movie: Equatable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    
    /// 포스터 이미지 전체 URL 생성
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    /// 평점을 0-5 스케일로 변환
    var normalizedRating: Double {
        voteAverage / 2.0
    }
}
