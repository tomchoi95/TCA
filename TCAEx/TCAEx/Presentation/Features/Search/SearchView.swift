//
//  SearchView.swift
//  TCAEx
//
//  Created by Tom Choi on 2/10/26.
//

import ComposableArchitecture
import SwiftUI

struct SearchView: View {
    @Bindable var store: StoreOf<SearchFeature>
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 검색 바
                searchBar
                
                // 컨텐츠 영역
                contentView
            }
            .navigationTitle("영화 검색")
            .navigationDestination(
                item: $store.scope(state: \.destination?.detail, action: \.destination.detail)
            ) { detailStore in
                MovieDetailView(store: detailStore)
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("영화 제목을 입력하세요", text: $store.searchQuery.sending(\.searchQueryChanged))
                .textFieldStyle(.plain)
                .autocorrectionDisabled()
            
            if !store.searchQuery.isEmpty {
                Button {
                    store.send(.searchQueryChanged(""))
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    // MARK: - Content View
    @ViewBuilder
    private var contentView: some View {
        if store.isLoading {
            loadingView
        } else if let errorMessage = store.errorMessage {
            errorView(message: errorMessage)
        } else if store.movies.isEmpty && !store.searchQuery.isEmpty {
            emptyView
        } else if store.movies.isEmpty {
            placeholderView
        } else {
            movieListView
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("검색 중...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Error View
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Empty View
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("검색 결과가 없습니다")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Placeholder View
    private var placeholderView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("영화를 검색해보세요")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Movie List View
    private var movieListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(store.movies) { movie in
                    MovieRowView(movie: movie)
                        .onTapGesture {
                            store.send(.movieTapped(movie))
                        }
                }
            }
            .padding()
        }
    }
}

// MARK: - Movie Row View
struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 포스터 이미지
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            
            // 영화 정보
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", movie.normalizedRating))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(movie.releaseDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(movie.overview)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    SearchView(
        store: Store(
            initialState: SearchFeature.State()
        ) {
            SearchFeature()
        }
    )
}
