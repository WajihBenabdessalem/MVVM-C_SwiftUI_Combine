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
    @Environment(NetworkMonitor.self) private var networkMonitor
    @State private var showNetworkAlert = false
    let state: ViewState<T>
    let request: (() -> Void)?
    let content: (T) -> Content
    //
    init(state: ViewState<T>, request: (() -> Void)? = nil, content: @escaping (T) -> Content) {
        self.state = state
        self.request = request
        self.content = content
    }
    //
    var body: some View {
        Group {
            switch state {
            case .idle:
                Color.clear
            case let .loading(data):
                LoadingView(data: data, content: content)
            case let .loaded(data):
                ResultContentView(data: data, content: content)
            case let .failed(error):
                ErrorView(error: error, retry: request)
            }
        }
        .onChange(of: networkMonitor.isConnected) { _, new in
            showNetworkAlert = !new
        }
        .popover(isPresented: $showNetworkAlert) { NoInternetView() }
    }
}

extension ResultView {
    /// Loading View
    struct LoadingView: View {
        let data: T?
        let content: (T) -> Content
        //
        var body: some View {
            Group {
                if let loadingData = data {
                    content(loadingData).redacted(reason: .placeholder)
                } else {
                    ProgressView { Text("Loading...") }
                }
            }
        }
    }
    /// Result Content View
    struct ResultContentView: View {
        let data: T
        let content: (T) -> Content
        //
        var body: some View {
            content(data)
        }
    }
    /// Error View
    struct ErrorView: View {
        let error: ApiError
        let retry: (() -> Void)?
        //
        var body: some View {
            ContentUnavailable(error: error, retry: retry)
        }
    }
}
