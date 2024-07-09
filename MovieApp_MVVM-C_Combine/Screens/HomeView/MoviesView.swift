//
//  MoviesView.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/2/24.
//

import SwiftUI

struct MoviesView: View {
    @StateObject var viewModel = MoviesViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @Environment(\.imageCache) private var cache: ImageCache

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                SearchBar(text: $viewModel.searchQuery)
                PickerView(selected: $viewModel.selectedCategory)
                ResultView(state: viewModel.viewState, retry: {
                    viewModel.fetchMovies(viewModel.selectedCategory ?? .popular)
                }) { movies in
                    MovieListView(viewModel, cache: cache) { movieId in
                        coordinator.push(.detail(movieId))
                    }
                }
                .onAppear {
                    viewModel.fetchMovies(viewModel.selectedCategory ?? .popular)
                }
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page:page)
                }
                .navigationTitle(viewModel.selectedCategory?.title ?? "Popular")
                .navigationBarTitleDisplayMode(.large)
            }
            .preferredColorScheme(.dark)
        }
    }
}

extension MoviesView {
    struct MovieRowView: View {
        let movie: Movie
        let cache: ImageCache
        
        init(movie: Movie, cache: ImageCache) {
            self.movie = movie
            self.cache = cache
        }
        
        var body: some View {
            HStack(spacing: 9) {
                AsyncImageView(
                    url: movie.poster!,
                    cache: cache,
                    placeholder: {
                        Spinner(isAnimating: true, style: .medium)
                    },
                    image: {
                        Image(uiImage: $0)
                        .resizable()
                        .renderingMode(.original)
                    }
                )
                .frame(width: 100)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                VStack(alignment: .leading, spacing: 8) {
                    Group {
                        Text(movie.title)
                            .font(.custom(AppFont.InterBold, size: 20))
                            .foregroundStyle(Color.titleTintColor)
                        HStack(spacing: 7) {
                            PopularityBadge(score: Int(movie.vote_average * 10))
                            Text(movie.release_date.toDate(),
                                 format:.dateTime.day().month().year())
                            .font(.headline)
                            .foregroundColor(.primary)
                        }
                        Text(movie.overview)
                            .font(.headline)
                            .lineLimit(3)
                    }
                    .foregroundStyle(.gray)
                    Spacer()
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
            }
            .frame(height: 151)
        }
    }
    
    struct MovieListView: View {
        @ObservedObject var viewModel: MoviesViewModel
        let cache: ImageCache
        let action: (Int) -> Void

        init(_ viewModel: MoviesViewModel, cache: ImageCache, action: @escaping (Int) -> Void) {
            self.viewModel = viewModel
            self.cache = cache
            self.action = action
        }
        
        var body: some View {
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel.movies, id: \.id) { movie in
                            MovieRowView(movie: movie, cache: cache)
                                .onTapGesture { action(movie.id) }
                        }
                    }.padding(.horizontal)
                }
                .onChange(of: viewModel.selectedCategory) { _,_ in
                    withAnimation {
                        if let firstMovieId = viewModel.movies.first?.id {
                            proxy.scrollTo(firstMovieId, anchor: .top)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Coordinator().build(page: .home)
}
