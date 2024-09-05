//
//  MovieDetailViewModel.swift
//  MVVMCSwiftUICombine
//
//  Created by Wajih Benabdessalem on 6/8/24.
//

import SwiftUI
import Combine

@Observable
final class MovieDetailViewModel {
    var state: ViewState<MovieDetail> = .idle
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: ApiClient
    var movieID: Int = -1
    //
    init(apiClient: ApiClient = .shared,
         movieID: Int) {
        self.apiClient = apiClient
        self.movieID = movieID
        self.fetchMovieDetail()
    }
    //
    func fetchMovieDetail() {
        self.state = .loading(MovieDetailViewModel.loadingItem)
        self.apiClient.request(MovieEndPoints.movieDetails(self.movieID))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Successfully received movie's detail")
                case let .failure(error):
                    self.state = .failed(error)
                }
            }, receiveValue: { [weak self] (movieDetail: MovieDetail) in
                guard let self else { return }
                self.state = .loaded(movieDetail)
            })
            .store(in: &self.cancellables)
    }
}

extension MovieDetailViewModel {
    static var loadingItem: MovieDetail {
        return MovieDetail(id: 1,
                           title: UUID().uuidString,
                           overview: UUID().uuidString,
                           poster_path: UUID().uuidString,
                           vote_average: 50.0,
                           genres: [],
                           release_date: UUID().uuidString,
                           runtime: 1,
                           spoken_languages: [])
    }
}
