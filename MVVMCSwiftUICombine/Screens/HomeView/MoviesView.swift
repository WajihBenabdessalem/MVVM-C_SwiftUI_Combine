//
//  MoviesView.swift
//  MVVMCSwiftUICombine
//
//  Created by Wajih Benabdessalem on 6/2/24.
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @Environment(\.imageCache) private var cache: ImageCache
    //
    var body: some View {
        VStack(spacing: 20) {
            SearchBar(text: $viewModel.searchQuery)
            PickerView(selected: $viewModel.selectedCategory)
            ResultView(state: viewModel.state, request: {
                viewModel.fetchMovies(viewModel.selectedCategory)
            }, content: { movies in
                movieListView(movies)
            })
            .overlay { noSearchResultView() }
        }
        .padding(.horizontal, 10)
        .navigationTitle(viewModel.selectedCategory.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

private extension MoviesView {
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
        }.refreshable {
            viewModel.fetchMovies(viewModel.selectedCategory)
        }
    }
    //
    @ViewBuilder
    func movieRowView(movie: Movie, cache: ImageCache) -> some View {
        HStack(spacing: 9) {
            AsyncImageView(
                url: movie.poster!,
                cache: cache,
                placeholder: {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray.opacity(0.5))
                }, image: { Image(uiImage: $0).resizable() }
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
    //
    @ViewBuilder
    func noSearchResultView() -> some View {
        if viewModel.isNoSearchResult {
            ContentUnavailableView.search(text: viewModel.searchQuery)
        }
    }
}

#Preview {
    @Previewable @State var coordinator: Coordinator = Coordinator()
    @Previewable @State var networkMonitor: NetworkMonitor = NetworkMonitor()
    NavigationStack {
        Coordinator().build(page: .home)
            .environmentObject(coordinator)
            .environmentObject(networkMonitor)
    }
}
