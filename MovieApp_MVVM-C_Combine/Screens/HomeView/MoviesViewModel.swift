//
//  MoviesViewModel.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/2/24.
//

import Foundation
import Combine

final class MoviesViewModel: ObservableObject {
    @Published var state: ViewState<[Movie]> = .idle
    @Published private(set) var filteredMovies: [Movie] = []
    @Published var searchQuery: String = ""
    @Published var isNoSearchResult: Bool = false
    @Published var selectedCategory: MovieType = .popular {
        didSet {
            fetchMovies(selectedCategory)
        }
    }
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient = .shared) {
        self.apiClient = apiClient
        initSubscribers()
    }
    
    func fetchMovies(_ type: MovieType) {
        state = .loading
        self.apiClient.request(MovieEndPoints.movies(type))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Successfully received movies")
                case let .failure(error):
                    self?.state = .error(error)
                }
            }, receiveValue: { [weak self] (response: MoviesResponse) in
                self?.state = .loaded(response.results)
            })
            .store(in: &self.cancellables)
    }
}

extension MoviesViewModel {
    func initSubscribers() {
        $searchQuery
            .removeDuplicates()
            .combineLatest($state)
            .map { [weak self] (query, state) -> [Movie] in
                guard case let .loaded(movies) = state else { return [] }
                let searchResult = movies.filter { $0.title.lowercased().contains(query.lowercased()) }
                self?.isNoSearchResult = searchResult.isEmpty && !query.isEmpty
                return query.isEmpty ? movies : searchResult
            }
            .assign(to: \.filteredMovies, on: self)
            .store(in: &cancellables)
    }
}
