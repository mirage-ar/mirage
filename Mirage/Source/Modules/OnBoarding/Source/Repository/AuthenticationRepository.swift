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
    func verifyUser(number: String, code: String) -> AnyPublisher<(User?, String?), Error>
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
    
    public func verifyUser(number: String, code: String) -> AnyPublisher<(User?, String?), Error> {
                
        let input = MirageAPI.VerificationInput(phone: number, code: code)
        let mutaiton = MirageAPI.VerifyUserMutation(verifyUserInput: input)
        return perform(mutation: mutaiton)
            .map {
                return ($0.verifyUser.map { response in
                    self.handleTokenUpdate(response.accessToken)
                    self.userPropertiesStorage.save(response.user.id, for: .userId)
                    self.userPropertiesStorage.save(response.accessToken, for: .accessToken)
                    let user = (User(verifyUser: response.user))
                    self.userProfileStorage.save(user, property: .userProfile)
                    return user
                }, $0.verifyUser?.accessToken)
            }
            .eraseToAnyPublisher()

    }

}

