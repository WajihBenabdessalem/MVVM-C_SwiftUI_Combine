//
//  Rooter.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/9/24.
//

import SwiftUI

// MARK: - Page.

enum Page: Hashable {
    case home
    case detail(Int)
}

// MARK: - Coordinator.

class Coordinator: ObservableObject {

    ///  Pullished variable property wrapper.
    @Published var path = NavigationPath()
    @Published var currentPage: Page = .home
    ///  Method to push the view to the child view.
    func push(_ page: Page) {
        path.append(page)
        currentPage = page
    }
    ///  Method to pop the child view to the parent view.
    func pop() {
        path.removeLast()
    }
    ///  Method to pop the view to the root view..
    func popToRoot() {
        path.removeLast(path.count)
        currentPage = .home
    }
    /// Build the view according to the enum `Page`
    @ViewBuilder
    func build(page: Page) -> some View {
        Group {
            switch page {
            case .home:
                MoviesView()
            case let .detail(id):
                MovieDetailView(viewModel: MovieDetailViewModel(movieID: id))
            }
        }
        .preferredColorScheme(.dark)
    }
}
