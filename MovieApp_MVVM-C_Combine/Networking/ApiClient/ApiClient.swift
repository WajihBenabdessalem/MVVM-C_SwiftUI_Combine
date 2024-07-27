//
//  ApiClient.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 6/28/24.
//

import Foundation
import Combine

protocol ApiService {
    func request<T: Decodable>(_ endpoint: EndPoint) -> AnyPublisher<T, ApiError>
}

struct ApiClient: ApiService {
    /// Static property for singleton instance.
    static let shared = ApiClient()
    
    private init() { }
    /// Default implementation for the request method within the ApiService protocol.
    func request<T: Decodable>(_ endPoint: EndPoint) -> AnyPublisher<T, ApiError> {
        #if DEBUG
        print("Sending request 📡 ...\nURLRequest info:  \(endPoint.urlRequest.url?.absoluteString ?? "N/A")\n###################\n")
        #endif
        return URLSession.shared.dataTaskPublisher(for: endPoint.urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse, 
                        (200..<300) ~= response.statusCode else {
                    throw ApiError.invalidResponse
                }
                #if DEBUG
                print("Response ✅ statusCode \(response.statusCode) :\n" ,data.prettyJson)
                #endif
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let apiError = error as? ApiError {
                    return apiError
                } else if error is DecodingError {
                    return ApiError.decodingError(error)
                } else if error is URLError {
                    return ApiError.invalidURL
                } else {
                    return ApiError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
}
