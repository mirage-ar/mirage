//
//  AuthenticationRepository.swift
//  Mirage
//
//  Created by Saad on 07/03/2023.
//

import Foundation
import Combine

protocol AuthenticationRepository {
    
    func authenticate(number: String) -> AnyPublisher<Bool, Error>
}

extension ApolloRepository: AuthenticationRepository {
    public func authenticate(number: String) -> AnyPublisher<Bool, Error> {
        let input = AuthorizationInput(phone: number)
        return perform(mutation: AuthorizeUserMutation(input: input))
            .map {
                print($0.verificationSid)
//                handleUserAuthentication($0.)
            }
    }
}
