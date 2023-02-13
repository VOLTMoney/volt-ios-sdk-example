//
//  ReachabilityMonitor.swift
//  VoltFramework
//
//  Created by 
//

import Foundation
import Network

enum ReachabilityStatus: String {
    case connected
    case disconnected
}

final class ReachabilityMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")

    static let shared = ReachabilityMonitor()

    var status: ReachabilityStatus = .connected

    private init() { }

    func start() {
        self.monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.status = (path.status == .satisfied) ? .connected : .disconnected
            }
        }

        self.monitor.start(queue: self.queue)
    }
}
