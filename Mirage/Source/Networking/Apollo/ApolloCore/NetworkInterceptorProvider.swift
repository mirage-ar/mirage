//
//  NetworkInterceptorProvider.swift
//  Mirage
//
//  Created by Saad on 01/03/2023.
//

import Foundation
import Apollo
import ApolloAPI

class NetworkInterceptorProvider: InterceptorProvider {

    private let store: ApolloStore
    private let client: URLSessionClient

    private let userTokenService: UserTokenService

    init(store: ApolloStore,
         client: URLSessionClient,
         userTokenService: UserTokenService) {
        self.store = store
        self.client = client

        self.userTokenService = userTokenService
    }

    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        [
            MaxRetryInterceptor(),
            CacheReadInterceptor(store: store),
            UserTokenInterceptor(userTokenService: userTokenService),
            AddTokenInterceptor(),
            NetworkFetchInterceptor(client: client),
            ResponseCodeInterceptor(),
            JSONResponseParsingInterceptor(),
            AutomaticPersistedQueryInterceptor(),
            CacheWriteInterceptor(store: store)
        ]
    }
}
