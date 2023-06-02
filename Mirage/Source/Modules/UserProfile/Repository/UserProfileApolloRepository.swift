//
//  UserProfileApolloRepository.swift
//  Mirage
//
//  Created by Saad on 07/05/2023.
//

import Foundation
import Combine
import CoreLocation

protocol UserProfileApolloRepository {
    
    func updateUser(user: User) -> AnyPublisher<User, Error>
    func getUser(id: String, accessToken: String) -> AnyPublisher<User, Error>

}

extension ApolloRepository: UserProfileApolloRepository {
    
    func updateUser(user: User) -> AnyPublisher<User, Error> {
        
        let input = MirageAPI.UpdateUserInput(userId: user.id, accessToken: "1", username: user.userName ?? "" , profileDescription: user.profileDescription ?? "") //?? part is just to avoid error.
        let mutaiton = MirageAPI.UpdateUserMutation(updateUserInput: input)
        return perform(mutation: mutaiton)
            .map {
                return (user.updated(apiUpdatedUser: $0.updateUser))
            }
            .eraseToAnyPublisher()

    }
    
    func getUser(id: String, accessToken: String) -> AnyPublisher<User, Error> {
                
        let input = MirageAPI.AuthorizedQueryInput (userId: id, accessToken: accessToken)
        
        let query = MirageAPI.UserQuery(userInput: input)
        return fetch(query: query)
            .map {
                //TODO: update to user model
                return (User(apiUser: $0.user))
            }
            .eraseToAnyPublisher()

    }
}
