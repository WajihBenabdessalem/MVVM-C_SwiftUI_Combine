//
//  MovieEndPoints.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 7/1/24.
//

import Foundation

enum MovieEndPoints: EndPoint {
    case movies(MovieType)
    case movieDetails(Int)
    var path: String {
        switch self {
        case let .movies(type): "\(type)"
        case let .movieDetails(id): "\(id)"
        }
    }
    var method: HTTPMethod {
        switch self {
        case .movies, .movieDetails: .get
        }
    }
}

// MARK: - Movies Types

// swiftlint:disable identifier_name
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
// swiftlint:enable identifier_name
