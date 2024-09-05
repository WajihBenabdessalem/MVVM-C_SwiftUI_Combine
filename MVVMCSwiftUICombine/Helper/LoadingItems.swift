//
//  LoadingItems.swift
//  MVVMCSwiftUICombine
//
//  Created by Wajih Benabdessalem on 9/4/24.
//

import Foundation

struct LoadingItems {
    static var movies: [Movie] {
        var uniqueID = 0
        return (0..<20).map { _ in
            defer { uniqueID += 1 }
            return Movie(id: uniqueID,
                         title: UUID().uuidString,
                         poster_path: UUID().uuidString,
                         overview: UUID().uuidString,
                         release_date: UUID().uuidString,
                         popularity: 50.5,
                         vote_average: 0,
                         vote_count: 20)
        }
    }
}
