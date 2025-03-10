//
//  FriendsApolloRepository.swift
//  Mirage
//
//  Created by Saad on 06/11/2023.
//

import Foundation
import Combine

protocol FriendsApolloRepository {
    func sendFriendRequest(userId: UUID) -> AnyPublisher<FriendshipStatus, Error>
    func  updateFriendRequest(userId: UUID, status: FriendshipStatus) -> AnyPublisher<FriendshipStatus, Error>

}

extension ApolloRepository: FriendsApolloRepository {
    
    func sendFriendRequest(userId: UUID) -> AnyPublisher<FriendshipStatus, Error> {
        let mutaiton = MirageAPI.SendFriendRequestMutation(recipientId: userId.uuidString.lowercased())
        return perform(mutation: mutaiton)
            .map {
                return FriendshipStatus(stringValue: $0.sendFriendRequest.status.rawValue)
            }
            .eraseToAnyPublisher()
    }
    
    func updateFriendRequest(userId: UUID, status: FriendshipStatus) -> AnyPublisher<FriendshipStatus, Error> {
        let status = GraphQLEnum<MirageAPI.FriendshipStatus>(rawValue: status.stringValue)
        let input = MirageAPI.UpdateFriendshipInput(recipientId: userId.uuidString.lowercased(), status: status)
        let mutaiton = MirageAPI.UpdateFriendRequestMutation(input: input)
        return perform(mutation: mutaiton)
            .map {
                return FriendshipStatus(stringValue: $0.updateFriendRequest.status.rawValue)
            }
            .eraseToAnyPublisher()
    }
}
