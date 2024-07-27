//
//  ResultView.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 7/6/24.
//

import SwiftUI

enum ViewState<T> {
    case idle
    case loading(T?)
    case loaded(T)
    case failed(ApiError)
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
            case let .loading(data):
                if let loadingData = data {
                    content(loadingData).redacted(reason: .placeholder)
                } else {
                    ProgressView { Text("Loading...") }
                }
            case let .loaded(data):
                content(data)
            case let .failed(error):
                ContentUnavailable(error, retry: request)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .popover(isPresented: $showNetworkAlert) { NoInternetView() }
        .onChange(of: networkMonitor.isConnected) { old, new in
            showNetworkAlert = new == false
        }
        .onAppear { if let request = request { request() } }
    }
}
