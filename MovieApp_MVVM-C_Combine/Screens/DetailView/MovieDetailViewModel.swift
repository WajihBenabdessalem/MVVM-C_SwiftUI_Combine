//
//  MovieDetailViewModel.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/8/24.
//

import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject {
    @Published var viewState: ViewState<MovieDetail> = .idle
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: ApiClient
    private let movieID: Int
    
    init(apiClient: ApiClient = .shared,
         movieID: Int) {
        self.apiClient = apiClient
        self.movieID = movieID
    }
    
    func fetchMovieDetail() {
        self.viewState = .loading(nil)
        self.apiClient.request(MovieEndPoints.movieDetails(self.movieID))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Successfully received movie's detail")
                case let .failure(error):
                    self.viewState = .error(error)
                }
            }, receiveValue: { (movieDetail: MovieDetail) in
                self.viewState = .loaded(movieDetail)
            })
            .store(in: &self.cancellables)
    }
}
