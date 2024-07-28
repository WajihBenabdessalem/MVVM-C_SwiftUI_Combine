//
//  CoordinatorView.swift
//  MovieApp_VIP
//
//  Created by Wajih Benabdessalem on 6/9/24.
//

import SwiftUI

struct CoordinatorView: View {

    @StateObject private var coordinator = Coordinator()
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some View {
        coordinator.build(page: .home)
            .environmentObject(coordinator)
            .environmentObject(networkMonitor)
    }
}

#Preview {
    CoordinatorView()
}
