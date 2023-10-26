//
//  EnvironmentConfig.swift
//  Mirage
//
//  Created by Saad on 10/03/2023.
//

import Foundation
import Foundation


protocol EnvironmentConfig {
    
    // MARK: Apollo
    var apiEndpoint: String { get }
    var apiWebSocketEndpoint: String { get }
    var host: String { get }
}

enum MirageConfig: EnvironmentConfig {
    case production
    case staging
    case development
    
    
    // MARK: Apollo
    
    var apiEndpoint: String {
        switch self {
        case .production:
            return "https://sync.protocol.im/graphql/"
            
        case .staging:
            return "https://sync-dev.protocol.im/graphql/"
            
            
        case .development:
            return "https://sync-dev.protocol.im/graphql/"
            
        }
    }
    
    var apiWebSocketEndpoint: String {
        switch self {
        case .production:
            return "wss://sync.protocol.im/graphql/realtime"
            
        case .staging:
            return "wss://sync-dev.protocol.im/graphql/realtime"
            
        case .development:
            return "wss://sync-dev.protocol.im/graphql/realtime"
        }
    }
    var host: String {
        switch self {
        case .production:
            return "sync.protocol.im"
            
        case .staging:
            return "sync-dev.protocol.im"
            
            
        case .development:
            return "sync-dev.protocol.im"
            
        }
    }
}
