//
//  CoordinatorView.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/9/24.
//

import SwiftUI

struct CoordinatorView: View {
    @State private var coordinator = Coordinator()
    @State private var networkMonitor = NetworkMonitor()
    //
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .home)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environment(coordinator)
        .environment(networkMonitor)
    }
}

#Preview {
    CoordinatorView()
}
