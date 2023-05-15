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
    
    func updateUser(user: User) -> AnyPublisher<(String, String), Error>
    func getUser(id: String, accessToken: String) -> AnyPublisher<User, Error>

}

extension ApolloRepository: UserProfileApolloRepository {
    
    func updateUser(user: User) -> AnyPublisher<(String, String), Error> {
        
        let input = MirageAPI.UpdateUserInput(userId: user.id, accessToken: "1", username: user.userName ?? "" , bio: user.bio ?? "") //?? part is just to avoid error.
        let mutaiton = MirageAPI.UpdateUserMutation(updateUserInput: input)
        return perform(mutation: mutaiton)
            .map {
                return ($0.updateUser?.id ?? "", $0.updateUser?.username ?? "")
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
