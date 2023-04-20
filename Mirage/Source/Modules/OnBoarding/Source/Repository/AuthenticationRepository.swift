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
    func updateUser(id: String, accessToken: String, userName: String) -> AnyPublisher<(String, String), Error>
    func getUser(id: String, accessToken: String) -> AnyPublisher<String, Error>

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
                return ($0.verifyUser?.user.id ?? "", $0.verifyUser?.accessToken ?? "")
            }
            .eraseToAnyPublisher()

    }

    public func updateUser(id: String, accessToken: String, userName: String) -> AnyPublisher<(String, String), Error> {
        
        let input = MirageAPI.UpdateUserInput(userId: id, accessToken: accessToken) //?? part is just to avoid error.
        let mutaiton = MirageAPI.UpdateUserMutation(updateUserInput: input)
        return perform(mutation: mutaiton)
            .map {
                return ($0.updateUser?.id ?? "", $0.updateUser?.username ?? "")
            }
            .eraseToAnyPublisher()

    }
    
    public func getUser(id: String, accessToken: String) -> AnyPublisher<String, Error> {
                
        let input = MirageAPI.AuthorizedQueryInput (userId: id, accessToken: accessToken)
        let query = MirageAPI.UserQuery(authorizedQueryInput: input)
        return fetch(query: query)
            .map {
                //TODO: update to user model
                return ($0.user?.username ?? "")
            }
            .eraseToAnyPublisher()

    }

}

