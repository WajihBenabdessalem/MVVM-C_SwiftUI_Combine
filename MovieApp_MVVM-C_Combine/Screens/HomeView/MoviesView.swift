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
                ResultView(state: viewModel.state, request: {
                  viewModel.fetchMovies(viewModel.selectedCategory)
                }) { movies in
                  movieListView(viewModel.filteredMovies)
                }
                .overlay { noSearchResultView() }
                .navigationDestination(for: Page.self) { page in
                  coordinator.build(page:page)
                }
                .navigationTitle(viewModel.selectedCategory.title)
                .navigationBarTitleDisplayMode(.large)
            }
            .preferredColorScheme(.dark)
        }
    }
    
}

extension MoviesView {
    @ViewBuilder
    func movieListView(_ movies: [Movie]) -> some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(movies, id: \.id) { movie in
                        movieRowView(movie: movie, cache: cache)
                            .onTapGesture {
                                coordinator.push(.detail(movie.id))
                            }
                    }
                }.padding(.horizontal)
            }.onChange(of: viewModel.selectedCategory) { old, new in
                withAnimation {
                    if let firstMovieId = movies.first?.id {
                        proxy.scrollTo(firstMovieId, anchor: .top)
                    }
                }
            }
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
                        .fill(.gray.opacity(0.5))
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
