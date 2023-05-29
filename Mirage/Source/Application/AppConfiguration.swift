//
//  AppConfiguration.swift
//  Mirage
//
//  Created by Saad on 10/03/2023.
//

import Foundation

final class AppConfiguration {
    static let shared = AppConfiguration()
    var environmentConfig: EnvironmentConfig

    let apollo: ApolloRepository
    let reachabilityProvider: ReachabilityProvider

    // MARK: - Init

    init() {
        #if PROD
        environmentConfig = MirageConfig.production
        #elseif DEV
        environmentConfig = MirageConfig.development
        #else
        environmentConfig = MirageConfig.staging
        #endif

        let _ = LocationManager.shared
        reachabilityProvider = ReachabilityProvider()
        apollo = ApolloRepository(
            endpoint: environmentConfig.apiEndpoint,
            webSocketEndpoint: environmentConfig.apiWebSocketEndpoint,
            reachabilityProvider: reachabilityProvider
        )
    }

}
