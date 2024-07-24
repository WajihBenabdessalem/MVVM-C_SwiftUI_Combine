//
//  MoviesResponse.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 6/26/24.
//

import Foundation

// MARK: - DTOs

struct MoviesResponse<T: Codable>: Codable {
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    let results: [T]
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let poster_path: String?
    let overview: String
    let release_date: String
    let popularity: Double
    let vote_average: Double
    let vote_count: Int
    
    var poster: URL? {
        poster_path.map {
            URL(string: MovieEndPoints.movies(.popular).environment.imageBaseURL)!
                .appendingPathComponent($0)
        }
    }
}

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String?
    let vote_average: Double?
    let genres: [Genre]
    let release_date: String?
    let runtime: Int?
    let spoken_languages: [Language]
    
    var poster: URL? {
        poster_path.map {
            URL(string: MovieEndPoints.movieDetails(Int()).environment.imageBaseURL)!
                .appendingPathComponent($0)
        }
    }
    
    struct Genre: Codable {
        let id: Int
        let name: String
    }
    
    struct Language: Codable {
        let name: String
    }
}
