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
    @Published var authenitcation: Bool
    // MARK: - Init

    init() {
//        #if PROD
//        environmentConfig = MirageConfig.production
//        #elseif DEV
//        environmentConfig = MirageConfig.development
//        #else
//        environmentConfig = MirageConfig.staging
//        #endif
        authenitcation = UserDefaultsStorage().getString(for: .accessToken)?.isEmpty == false && UserDefaultsStorage().getUser() != nil
        environmentConfig = MirageConfig.development
        let _ = DownloadManager.shared
        let _ = LocationManager.shared
        reachabilityProvider = ReachabilityProvider()
        apollo = ApolloRepository(
            endpoint: environmentConfig.apiEndpoint,
            webSocketEndpoint: environmentConfig.apiWebSocketEndpoint,
            reachabilityProvider: reachabilityProvider
        )
    }

}
