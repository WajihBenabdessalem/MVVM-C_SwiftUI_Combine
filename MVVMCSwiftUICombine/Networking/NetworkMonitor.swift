//
//  NetworkMonitor.swift
//  MovieApp_MVVM-C_Combine
//
//  Created by Wajih Benabdessalem on 6/26/24.
//

import SwiftUI
import Network

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    @Published var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isConnected = (path.status == .satisfied)
            }
        }
        let monitorQueue = DispatchQueue(label: "NetworkMonitorQueue", qos: .background)
        networkMonitor.start(queue: monitorQueue)
    }
    deinit {
        networkMonitor.cancel()
    }
}
