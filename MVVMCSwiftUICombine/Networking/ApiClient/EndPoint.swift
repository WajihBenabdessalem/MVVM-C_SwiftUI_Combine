//
//  EndPoint.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 6/28/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var urlRequest: URLRequest { get }
}

extension EndPoint {
    //
    var environment: APIEnvironment {
        #if DEBUG
        return .development
        #elseif STAGING
        return .staging
        #else
        return .production
        #endif
    }
    //
    var baseURL: URL {
        guard let url = URL(string: environment.baseURL) else {
            fatalError("Invalid base URL")
        }
        return url
    }
    //
    var headers: [String: String] {
        ["Content-Type": "application/json"]
    }
    //
    var queryItems: [URLQueryItem] {
        [URLQueryItem(name: "api_key", value: ApiConfig.apiKey)]
    }
    //
    var urlRequest: URLRequest {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true)!
        components.queryItems = queryItems
        guard let url = components.url else {
            fatalError("Invalid URL components")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
}

// MARK: - ApiError.
enum ApiError: Error {
    case invalidURL
    case noResponse
    case requestFailed
    case invalidResponse
    case connectionError
    case decodingError(Error)
    case custom(description: String)
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString(AppString.invalidUrl, comment: "invalidURL")
        case .invalidResponse:
            return NSLocalizedString(AppString.invalidResponse, comment: "invalidResponse")
        case .requestFailed, .noResponse:
            return NSLocalizedString(AppString.requestFailed, comment: "decodingError")
        case .connectionError:
            return NSLocalizedString(AppString.connectionError, comment: "connectionError")
        case .decodingError(let error):
            return NSLocalizedString("Unable to decode \(error.localizedDescription)", comment: "decodingError")
        case .custom(description: let description):
            return NSLocalizedString(description, comment: "custom")
        }
    }
}
