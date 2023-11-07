//
//  UserProfileViewModel.swift
//  Mirage
//
//  Created by Saad on 04/05/2023.
//

import Foundation
import Combine

final class UserProfileViewModel: ObservableObject {
    let userId: UUID
    @Published var user: User?
    @Published var hasLoadedProfile: Bool
    let friendsApolloRepository: FriendsApolloRepository = AppConfiguration.shared.apollo
    let userProfileRepository: UserProfileApolloRepository = AppConfiguration.shared.apollo

    init(userId: UUID, user: User? = nil, hasLoadedProfile: Bool = false) {
        self.userId = userId
        self.user = user
        self.hasLoadedProfile = hasLoadedProfile
        loadProfile(userId)
    }
    func loadProfile(_ userId: UUID) {
        userProfileRepository.getUser(id: userId.uuidString)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                self.user = user
                self.hasLoadedProfile = true
                print("userProfileRepository.getUser, userId: \(user.id)")
            } receiveError: { error in
                print("Get profile user error \(error)" )
            }
    }
    
    func sendFriendRequest(userId: UUID) {
        friendsApolloRepository.sendFriendRequest(userId: userId)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { status in
                debugPrint("friendsApolloRepository.sendFriendRequest, userId: \(userId)")
            } receiveError: { error in
                print("Friend Request Failed \(error)" )
            }

    }
}

