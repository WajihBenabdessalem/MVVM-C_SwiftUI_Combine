//
//  MoviesView.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/2/24.
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @Environment(\.imageCache) private var cache: ImageCache

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                SearchBar(text: $viewModel.searchQuery)
                PickerView(selected: $viewModel.selectedCategory)
                ResultView(state: viewModel.state, request: {
                    viewModel.fetchMovies(viewModel.selectedCategory)
                }, content: { movies in
                    movieListView(movies)
                })
                .overlay { noSearchResultView() }
            }
            .navigationTitle(viewModel.selectedCategory.title)
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: Page.self) { page in
                coordinator.build(page:page)
            }
        }
        .preferredColorScheme(.dark)
    }
}

extension MoviesView {
    @ViewBuilder
    func movieListView(_ movies: [Movie]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(movies, id: \.id) { movie in
                    movieRowView(movie: movie, cache: cache)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            coordinator.push(.detail(movie.id))
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func movieRowView(movie: Movie, cache: ImageCache) -> some View {
        HStack(spacing: 9) {
            AsyncImageView(
                url: movie.poster!,
                cache: cache,
                placeholder: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.5))
                },image: { Image(uiImage: $0).resizable() }
            )
            .frame(width: 100)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.custom(AppFont.InterBold, size: 20))
                    .foregroundColor(Color.titleTintColor)
                HStack(spacing: 7) {
                    PopularityBadge(score: Int(movie.vote_average * 10))
                    Text(movie.release_date.toDate(), format: .dateTime.day().month().year())
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Text(movie.overview)
                    .font(.headline)
                    .lineLimit(3)
                    .foregroundColor(.gray)
                Spacer()
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
        }
        .frame(height: 151)
    }

    @ViewBuilder
    func noSearchResultView() -> some View {
        if viewModel.isNoSearchResult {
            ContentUnavailableView.search(text: viewModel.searchQuery)
        }
    }
}

#Preview {
    Coordinator().build(page: .home)
}
