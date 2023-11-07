//
//  FriendsApolloRepository.swift
//  Mirage
//
//  Created by Saad on 06/11/2023.
//

import Foundation
import Combine

protocol FriendsApolloRepository {
    func sendFriendRequest(userId: UUID) -> AnyPublisher<String, Error>
}

extension ApolloRepository: FriendsApolloRepository {
    func sendFriendRequest(userId: UUID) -> AnyPublisher<String, Error> {
        
        let mutaiton = MirageAPI.SendFriendRequestMutation(recipientId: userId.uuidString.lowercased())
        return perform(mutation: mutaiton)
            .map {
                return $0.sendFriendRequest.status.rawValue
            }
            .eraseToAnyPublisher()
    }
}
