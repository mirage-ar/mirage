//
//  UserProfileApolloRepository.swift
//  Mirage
//
//  Created by Saad on 07/05/2023.
//

import Combine
import CoreLocation
import Foundation

protocol UserProfileApolloRepository {
    func updateUser(user: User) -> AnyPublisher<User, Error>
    func getUser(id: String?) -> AnyPublisher<User, Error>
}

extension ApolloRepository: UserProfileApolloRepository {
    func updateUser(user: User) -> AnyPublisher<User, Error> {
        let input = MirageAPI.UpdateUserInput(username: user.userName ?? "", profileImage: GraphQLNullable<String>(stringLiteral: user.profileImage), profileDescription: user.profileDescription ?? "") // ?? part is just to avoid error.
        let mutaiton = MirageAPI.UpdateUserMutation(updateUserInput: input)
        return perform(mutation: mutaiton)
            .map {
                return (user.updated(apiUpdatedUser: $0.updateUser))
            }
            .eraseToAnyPublisher()
    }

    func getUser(id: String?) -> AnyPublisher<User, Error> {
        print("getUser, userId: \(String(describing: id))")
        let query = MirageAPI.UserQuery(userId: id ?? "")
        return fetch(query: query)
            .map {
                return (User(apiUser: $0.user))
            }
            .eraseToAnyPublisher()
    }
}
