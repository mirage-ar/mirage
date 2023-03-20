//
//  Reachability.swift
//  Mirage
//
//  Created by Saad on 01/03/2023.
//

import UIKit
import Combine
import Reachability

public protocol ReachabilityProtocol {
    /// Whether a device is connected to the network
    var hasConnection: Bool { get }

    /// For check network connection
    var reachable: AnyPublisher<Bool, Never> { get }

    /// Gets latest network state
    func refreshNetworkState()

    /// For check network error
    func checkIfNetworkFailed(handled error: Error) -> Error

    /// Describes what is the type of connection
    var connectionDescription: String { get }

}

public class ReachabilityProvider: ReachabilityProtocol {
    
    public lazy var reachable = reachableSubject.eraseToAnyPublisher()

    /// Whether a device is connected to the network
    public var hasConnection: Bool {
        reachability?.connection != .unavailable
    }
    public var connectionDescription: String {
        reachability?.connection.description ?? "-"
    }

    private let reachability: Reachability?
    private var reachableSubject = PassthroughSubject<Bool, Never>()

    public init() {
        self.reachability = try? Reachability()

        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        try? self.reachability?.startNotifier()
    }

    deinit {
        guard let reachability = reachability else { return }

        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }

    @objc func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability else { return }
        switch reachability.connection {
        case .wifi, .cellular:
            reachableSubject.send(true)
        case .unavailable:
            reachableSubject.send(false)
        }
    }

    /// Gets latest network state
    public func refreshNetworkState() {
        reachableSubject.send(hasConnection)
    }

    public func checkIfNetworkFailed(handled error: Error) -> Error {
        guard let reachability = reachability else { return error }

        switch reachability.connection {
        case .unavailable:
            return NetworkError.networkError
        default:
            return error
        }
    }

}
