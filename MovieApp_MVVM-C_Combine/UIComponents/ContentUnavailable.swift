//
//  ContentUnavailable.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 7/8/24.
//

import SwiftUI

struct ContentUnavailable: View {
    let error: ApiError?
    let retry: (() -> Void)?
    
    init(_ error: ApiError?, retry: (() -> Void)?) {
        self.error = error
        self.retry = retry
    }
    
    var body: some View {
        let errorDescription = error?.errorDescription ?? ""
        return ContentUnavailableView {
            Label("Oops!", systemImage: "exclamationmark.triangle")
                .tint(.white)
        } description: {
            Text("Sorry, something went wrong while fetching data.\n" + errorDescription)
                .tint(.white)
                .multilineTextAlignment(.center)
        } actions: {
            if let retry = retry {
                Button { retry() } label: {
                    Text("Retry")
                        .bold()
                        .tint(.white)
                        .padding(.horizontal, 17)
                        .padding(.vertical, 9)
                        .background(RoundedRectangle(cornerRadius: 25))
                }
            }
        }
    }
}
