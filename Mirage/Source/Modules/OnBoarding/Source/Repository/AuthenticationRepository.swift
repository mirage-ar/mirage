//
//  AuthenticationRepository.swift
//  Mirage
//
//  Created by Saad on 07/03/2023.
//

import Foundation
import Combine

protocol AuthenticationRepository {
    
    func authenticate(number: String) -> AnyPublisher<String, Error>
    func verifyUser(number: String, code: String) -> AnyPublisher<(String, String), Error>
}

extension ApolloRepository: AuthenticationRepository {
    
    public func authenticate(number: String) -> AnyPublisher<String, Error> {
                
        let input = MirageAPI.AuthorizationInput(phone: number)
        let mutaiton = MirageAPI.AuthorizeUserMutation(authorizeUserInput: input)
        return perform(mutation: mutaiton)
            .map {
                //TODO: check in case of failure
                return $0.authorizeUser?.accountStage.rawValue ?? "UNKNOWN"
            }
            .eraseToAnyPublisher()

    }
    
    public func verifyUser(number: String, code: String) -> AnyPublisher<(String, String), Error> {
                
        let input = MirageAPI.VerificationInput(phone: number, code: code)
        let mutaiton = MirageAPI.VerifyUserMutation(verifyUserInput: input)
        return perform(mutation: mutaiton)
            .map {
                self.userPropertiesStorage.save($0.verifyUser?.user.id, for: .userId)
                self.userPropertiesStorage.save($0.verifyUser?.accessToken, for: .accessToken)
                return ($0.verifyUser?.user.id ?? "", $0.verifyUser?.accessToken ?? "")
            }
            .eraseToAnyPublisher()

    }

}

