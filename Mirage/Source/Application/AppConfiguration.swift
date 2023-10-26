//
//  AppConfiguration.swift
//  Mirage
//
//  Created by Saad on 10/03/2023.
//

import Foundation

final class AppConfiguration: ObservableObject {
    static let shared = AppConfiguration()
    var environmentConfig: EnvironmentConfig

    let apollo: ApolloRepository
    let reachabilityProvider: ReachabilityProvider
    @Published var authentication: Bool
    @Published var getStartedLaunched: Bool

    // MARK: - Init

    init() {
        #if PROD
        environmentConfig = MirageConfig.production
        #elseif DEV
        environmentConfig = MirageConfig.development
        #else
        environmentConfig = MirageConfig.development
        #endif
        environmentConfig = MirageConfig.production

        print("environmentConfig: \(environmentConfig)")
        let authenticated = UserDefaultsStorage().getString(for: .accessToken)?.isEmpty == false && UserDefaultsStorage().getUser() != nil
        authentication = authenticated
        getStartedLaunched = authenticated//UserDefaultsStorage().getBool(for: .getStartedLaunched) // same as authentication
        let _ = DownloadManager.shared
        let _ = LocationManager.shared
        reachabilityProvider = ReachabilityProvider()
        apollo = ApolloRepository(
            apiEndPoint: environmentConfig.apiEndpoint,
            webSocketEndpoint: environmentConfig.apiWebSocketEndpoint,
            host: environmentConfig.host,
            reachabilityProvider: reachabilityProvider
        )
    }

}
