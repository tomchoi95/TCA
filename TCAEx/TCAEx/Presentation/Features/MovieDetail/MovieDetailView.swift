//
//  MovieDetailView.swift
//  TCAEx
//
//  Created by Tom Choi on 2/10/26.
//

import ComposableArchitecture
import SwiftUI

struct MovieDetailView: View {
    let store: StoreOf<MovieDetailFeature>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 포스터 이미지
                posterSection
                
                // 영화 정보
                infoSection
                
                // 줄거리
                overviewSection
            }
            .padding()
        }
        .navigationTitle(store.movie.title)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    // MARK: - Poster Section
    private var posterSection: some View {
        AsyncImage(url: store.movie.posterURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(2/3, contentMode: .fit)
                .overlay {
                    ProgressView()
                }
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Info Section
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 평점
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                
                Text(String(format: "%.1f", store.movie.normalizedRating))
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("/ 5.0")
                    .font(.title3)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            // 개봉일
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text("개봉일")
                    .foregroundColor(.secondary)
                Spacer()
                Text(store.movie.releaseDate)
                    .fontWeight(.medium)
            }
            .font(.subheadline)
            
            Divider()
        }
    }
    
    // MARK: - Overview Section
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("줄거리")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(store.movie.overview)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(
            store: Store(
                initialState: MovieDetailFeature.State(
                    movie: Movie(
                        id: 1,
                        title: "The Shawshank Redemption",
                        overview: "두 남자가 감옥에서 우정을 쌓고 구원과 최종 해방을 찾는 이야기입니다.",
                        posterPath: "/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
                        releaseDate: "1994-09-23",
                        voteAverage: 8.7
                    )
                )
            ) {
                MovieDetailFeature()
            }
        )
    }
}
