//
//  NetworkState.swift
//  RickAndMorty
//
//  Created by andrey perevedniuk on 16.02.2023.
//

import Foundation
import Network

class NetworkState {
    static let shared = NetworkState()
    
    var isConnected: Bool = false
    
    private let queue = DispatchQueue.main
    private let monitor: NWPathMonitor
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
}
