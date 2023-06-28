//
//  HomeApolloRepository.swift
//  Mirage
//
//  Created by fiigmnt on 6/27/23.
//

import Combine
import CoreLocation
import Foundation

protocol HomeApolloRepository {
    func getUser() -> AnyPublisher<User, Error>
}

extension ApolloRepository: HomeApolloRepository {

    func getUser() -> AnyPublisher<User, Error> {
        let query = MirageAPI.UserQuery(userId: "")
        return fetch(query: query)
            .map {
                return (User(apiUser: $0.user))
            }
            .eraseToAnyPublisher()
    }
}

