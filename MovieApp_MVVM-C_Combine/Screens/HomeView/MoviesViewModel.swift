//
//  MoviesViewModel.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/2/24.
//

import Foundation
import Combine

final class MoviesViewModel: ObservableObject {
    @Published var viewState: ViewState<[Movie]> = .idle
    @Published var selectedCategory: MovieType?
    @Published var searchQuery: String = ""
    @Published private(set) var movies: [Movie] = []
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient = .shared) {
        self.apiClient = apiClient
        self.initSubscribers()
    }
    
    func fetchMovies(_ type: MovieType) {
        viewState = .loading
        self.apiClient.request(MovieEndPoints.movies(type))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    print("Successfully received movies")
                case let .failure(error):
                    self?.viewState = .error(error)
                }
            }, receiveValue: { [weak self] (response: MoviesResponse) in
                self?.viewState = .loaded(response.results)
                self?.movies = response.results
            })
            .store(in: &self.cancellables)
    }
    
    func initSubscribers()  {
        $selectedCategory.sink { [weak self] newCategorie in
            if let catg = newCategorie {
                self?.fetchMovies(catg)
            }
        }
        .store(in: &self.cancellables)
        $searchQuery.sink { [weak self] newQuery in
            if let movies = self?.movies {
                self?.viewState = newQuery.isEmpty ? .loaded(movies) :
                    .loaded(movies.filter {
                        $0.title.lowercased().contains(newQuery.lowercased())
                    })
            }
        }
        .store(in: &self.cancellables)
    }
    
    deinit {
        cancellables.removeAll()
    }
}

// MARK: - Movies Types

enum MovieType: String, CaseIterable {
    case popular
    case upcoming
    case top_rated
    case now_playing
    
    var title: String {
        switch self {
        case .popular: "Popular"
        case .upcoming: "Upcoming"
        case .top_rated: "Top rated"
        case .now_playing: "Now playing"
        }
    }
}
