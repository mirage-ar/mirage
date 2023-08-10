//
//  NetworkError.swift
//  Mirage
//
//  Created by Saad on 01/03/2023.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case dataMissing
    case emptyData
    case requestError(message: String)
    case networkError
    case serverError
    case unauthenticated

    var recordToCrashReporter: Bool {
        switch self {
        case .unauthenticated, .networkError, .dataMissing, .emptyData:
            return false

        default:
            return true
        }
    }
    var message: String {
        switch self {
        case .requestError(message: let e):
            return e
        default:
            return ""
        }
    }
}
