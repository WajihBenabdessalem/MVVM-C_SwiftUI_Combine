//
//  MovieApp_MVVM_C_CombineApp.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 6/24/24.
//

import SwiftUI

@main
struct MovieApp_MVVM_C_CombineApp: App {
    @StateObject private var coordinator = Coordinator()
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            //CoordinatorView()
            MoviesView()
                .environmentObject(coordinator)
                .environmentObject(networkMonitor)
        }
    }
}
