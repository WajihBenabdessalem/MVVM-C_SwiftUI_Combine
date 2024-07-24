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
    let state: ViewState<T>
    let request: (() -> Void)?
    let content: (T) -> Content
    
    init(state: ViewState<T>, request: (() -> Void)? = nil, content: @escaping (T) -> Content) {
        self.state = state
        self.request = request
        self.content = content
    }
    
    var body: some View {
        Group {
            switch state {
            case .idle:
                Color.clear
            case .loading:
                ProgressView { Text("Loading...") }
            case let .loaded(data):
                content(data)
            case let .error(error):
                ContentUnavailable(error, retry: request)
            }
        }
        .onAppear { if let request = request { request() } }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: networkMonitor.isConnected) { old, new in
            showNetworkAlert = new == false
        }
        .popover(isPresented: $showNetworkAlert) { NoInternetView() }
    }
}
