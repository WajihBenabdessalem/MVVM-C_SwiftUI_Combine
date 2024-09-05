//
//  MoviesViewModel.swift
//  MVVMCSwiftUICombine
//
//  Created by Wajih Benabdessalem on 6/2/24.
//

import Foundation
import SwiftUI
import Combine

@Observable final class MoviesViewModel {
    private(set) var state: ViewState<[Movie]> = .idle
    private(set) var movies: [Movie] = []
    private var cancellables = Set<AnyCancellable>()
    var isNoSearchResult: Bool = false
    var searchQuery: String = "" { didSet { handleSearchQueryChange() } }
    var selectedCategory: MovieType = .popular { didSet { fetchMovies(selectedCategory) } }
    private let apiClient: ApiClient
    //
    init(apiClient: ApiClient = .shared) {
        self.apiClient = apiClient
        fetchMovies(.popular)
    }
    //
    func fetchMovies(_ type: MovieType) {
        state = .loading(LoadingItems.movies)
        apiClient.request(MovieEndPoints.movies(type))
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .finished:
                    print("Successfully received movies")
                case let .failure(error):
                    self.state = .failed(error)
                }
            }, receiveValue: { [weak self] (response: MoviesResponse) in
                guard let self else { return }
                let sortedMovies = response.results.sorted { (firstMovie: Movie, secondMovie: Movie) -> Bool in
                    firstMovie.title < secondMovie.title
                }
                self.movies = sortedMovies
                self.state = .loaded(sortedMovies)
            }).store(in: &cancellables)
    }
}

private extension MoviesViewModel {
    func handleSearchQueryChange() {
        guard !searchQuery.isEmpty else {
            state = .loaded(movies)
            isNoSearchResult = false
            return
        }
        let searchResult = movies.filter { $0.title.lowercased().contains(searchQuery.lowercased()) }
        isNoSearchResult = searchResult.isEmpty
        state = .loaded(searchResult)
    }
}
