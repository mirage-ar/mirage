//
//  AddTokenInterceptor.swift
//  Mirage
//
//  Created by Saad on 06/03/2023.
//

import Foundation
import Apollo
import ApolloAPI

/// Adds the access token to the header if it's present
class AddTokenInterceptor: ApolloInterceptor {

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            request.addHeader(name: .deviceIdKey, value: .deviceId)

            
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
    }
}
