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
