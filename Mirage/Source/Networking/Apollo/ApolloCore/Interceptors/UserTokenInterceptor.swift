//
//  UserTokenInterceptor.swift
//  Mirage
//
//  Created by Saad on 03/03/2023.
//

import Apollo
import Foundation
import ApolloAPI


/// Adds the access token to the header if it's present
class UserTokenInterceptor: ApolloInterceptor {

    private let userTokenService: UserTokenService

    init(userTokenService: UserTokenService) {
        self.userTokenService = userTokenService
    }

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {

        if let header = userTokenService.getAuthorizationHeader() {
            request.addHeader(name: header.key, value: header.value)
            request.addHeader(name: "userId", value: UserDefaultsStorage().getString(for: .userId) ?? "")
        }

        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
}

protocol UserTokenService {
    func getAccessToken() -> String?
    func saveAccessToken(_ token: String)
    func removeAccessToken()
}

extension UserTokenService {
    func getAuthorizationHeader() -> (key: String, value: String)? {
        guard let token = getAccessToken() else { return nil }

        return (key: "authorization", value: "Bearer \(token)")
    }
}

class DefaultUserTokenService: UserTokenService {
    private let secureStorage: SecureStorage

    init() {
        self.secureStorage = KeychainStorage()
    }

    /// Returns the user access token
    ///
    ///  - returns: An optional of the user access token
    ///
    func getAccessToken() -> String? {
        secureStorage.getString(with: .accessTokenSecureStorageKey)
    }

    /// Saves the user access token to a secure storage
    ///
    ///  - parameters:
    ///     - token: A token to be saved
    ///
    func saveAccessToken(_ token: String) {
        secureStorage.save(token, for: .accessTokenSecureStorageKey)
    }

    /// Removes the user access token from a secure storage
    func removeAccessToken() {
        secureStorage.remove(key: .accessTokenSecureStorageKey)
    }
}

extension String {
    static let accessTokenSecureStorageKey: String = "apollo-repository-access-token"
}
