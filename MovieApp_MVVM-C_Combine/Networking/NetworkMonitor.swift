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
    private let workerQueue = DispatchQueue(label: "Monitor", qos: .background)
    
    @Published var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.workerQueue.async {
                let status = path.status == .satisfied
                DispatchQueue.main.async {
                    self.isConnected = status
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
