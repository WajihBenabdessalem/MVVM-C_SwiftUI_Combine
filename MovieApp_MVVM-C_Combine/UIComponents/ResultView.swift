//
//  ResultView.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 7/6/24.
//

import SwiftUI

enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case error(ApiError)
}

struct ResultView<T, Content: View>: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @State private var showNetworkAlert = false
    var state: ViewState<T>
    var retry: (() -> Void)?
    var content: (T) -> Content
    
    var body: some View {
        Group {
            switch state {
            case .idle:
                Text("idle state")
            case .loading:
                ProgressView { Text("Loading...") }
            case let .loaded(data):
                content(data)
            case let .error(error):
                ContentUnavailable(error.localizedDescription,
                                   retry: retry)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: networkMonitor.isConnected) { _, isConnected in
            showNetworkAlert = isConnected == false
        }
        .popover(isPresented: $showNetworkAlert) {
            Text("Network connection seems to be offline.")
        }
    }
}
