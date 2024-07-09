//
//  ContentUnavailable.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 7/8/24.
//

import SwiftUI

struct ContentUnavailable: View {
    let message: String?
    let retry: (() -> Void)?
    
    init(_ message: String?, retry: (() -> Void)?) {
        self.message = message
        self.retry = retry
    }
    
    var body: some View {
        ContentUnavailableView {
            Label("Oops!", systemImage: "exclamationmark.triangle")
                .tint(.white)
        } description: {
            Text("Sorry, something went wrong while fetching data.\n" + "\(message ?? "")")
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
