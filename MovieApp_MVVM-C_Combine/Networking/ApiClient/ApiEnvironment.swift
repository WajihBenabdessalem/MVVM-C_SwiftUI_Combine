//
//  ApiEnvironment.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 6/28/24.
//

import Foundation

enum APIEnvironment {
    case development
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .development:
            return "https://api.themoviedb.org/3/movie"
        case .staging:
            return "staging.baseURL.com"
        case .production:
            return "production.baseURL.com"
        }
    }
    
    var imageBaseURL: String {
        switch self {
        case .development:
            return "https://image.tmdb.org/t/p/original/"
        case .staging:
            return "staging.imageBaseURL.com"
        case .production:
            return "production.imageBaseURL.com"
        }
    }
}
