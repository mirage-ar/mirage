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
}

enum MirageConfig: EnvironmentConfig {
    case production
    case staging
    case development
    
    
    // MARK: Apollo
    
    var apiEndpoint: String {
        switch self {
        case .production:
            return "https://graph.protocol.im/"
            
        case .staging:
            return "https://graph.protocol.im/"
            
        case .development:
            return "https://graph.protocol.im/"
        }
    }
    
    var apiWebSocketEndpoint: String {
        switch self {
        case .production:
            return "wss://graph.protocol.im/"
            
        case .staging:
            return "wss://graph.protocol.im/"
            
        case .development:
            return "https://graph.protocol.im/"
        }
    }
}
