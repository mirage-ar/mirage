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

let url = "https://gpwdv17dp3.execute-api.us-east-1.amazonaws.com/" //temporary

enum MirageConfig: EnvironmentConfig {
    case production
    case staging
    case development
    
    
    // MARK: Apollo
    
    var apiEndpoint: String {
        switch self {
        case .production:
            return "https://graph-dev.protocol.im/"
            
        case .staging:
            return "https://graph-dev.protocol.im/"
            
        case .development:
            return url
        }
    }
    
    var apiWebSocketEndpoint: String {
        switch self {
        case .production:
            return "wss://graph-dev.protocol.im/"
            
        case .staging:
            return "wss://graph-dev.protocol.im/"
            
        case .development:
            return url
        }
    }
}
