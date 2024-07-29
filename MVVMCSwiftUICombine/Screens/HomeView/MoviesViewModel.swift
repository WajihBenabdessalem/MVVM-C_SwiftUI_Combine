//
//  MoviesViewModel.swift
//  MVVMCSwiftUICombine
//
//  Created by Wajih Benabdessalem on 6/2/24.
//

import Foundation
import Combine

final class MoviesViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Movie]> = .idle
    @Published private(set) var movies: [Movie] = []
    @Published var searchQuery: String = ""
    @Published var isNoSearchResult: Bool = false
    @Published var selectedCategory: MovieType = .popular {
        didSet {
            fetchMovies(selectedCategory)
        }
    }
    /// A store for subscriptions
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: ApiClient
    //
    init(apiClient: ApiClient = .shared) {
        self.apiClient = apiClient
        initSubscribers()
    }
    //
    func fetchMovies(_ type: MovieType) {
        state = .loading(MoviesViewModel.loadingItems)
        self.apiClient.request(MovieEndPoints.movies(type))
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Successfully received movies")
                case let .failure(error):
                    self?.state = .failed(error)
                }
            }, receiveValue: { [weak self] (response: MoviesResponse) in
                guard let self else { return }
                self.movies = response.results
                self.state = .loaded(response.results)
            })
            .store(in: &self.cancellables)
    }
}

private extension MoviesViewModel {
    func initSubscribers() {
        $searchQuery
            .dropFirst()
            .removeDuplicates()
            .combineLatest($state)
            .map { [weak self] (query, state) -> ViewState in
                guard let self, case .loaded = state else { return .idle }
                let searchResult = self.movies.filter { $0.title.lowercased().contains(query.lowercased()) }
                self.isNoSearchResult = searchResult.isEmpty && !query.isEmpty
                return query.isEmpty ? .loaded(self.movies) : .loaded(searchResult)
            }
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.state, on: self)
            .store(in: &cancellables)
    }
}

private extension MoviesViewModel {
    static var loadingItems: [Movie] {
        var uniqueID = 0
        return (0..<20).map { _ in
            defer { uniqueID += 1 }
            return .init(id: uniqueID,
                         title: UUID().uuidString,
                         poster_path: UUID().uuidString,
                         overview: UUID().uuidString,
                         release_date: UUID().uuidString,
                         popularity: 50.5,
                         vote_average: 0,
                         vote_count: 20)
        }
    }
}
