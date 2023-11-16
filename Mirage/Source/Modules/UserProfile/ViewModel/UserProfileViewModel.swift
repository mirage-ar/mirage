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
    @Published var updatingFriendship: Bool = false

    init(userId: UUID, user: User? = nil, hasLoadedProfile: Bool = false) {
        self.userId = userId
        self.user = user
        self.hasLoadedProfile = hasLoadedProfile
        loadProfile(userId)
    }
    func refreshProfile() {
        self.loadProfile(self.userId)
    }
    func loadProfile(_ userId: UUID) {
        userProfileRepository.getUser(id: userId.uuidString.lowercased())
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                self.user = user
                self.hasLoadedProfile = true
                self.updatingFriendship = false
                print("userProfileRepository.getUser, userId: \(user.id)")
            } receiveError: { error in
                print("Get profile user error \(error)" )
                
            }
    }
    
    func sendFriendRequest(userId: UUID) {
        updatingFriendship = true
        friendsApolloRepository.sendFriendRequest(userId: userId)
            .receiveAndCancel { status in
                    self.loadProfile(userId)
            
                debugPrint("friendsApolloRepository.sendFriendRequest, userId: \(userId)")
            } receiveError: { error in
                print("Friend Request Failed \(error)" )
                self.updatingFriendship = false

            }

    }
    func updateFriendship(targetStatus: FriendshipStatus, userId: UUID) {
        if targetStatus == .requested {
            sendFriendRequest(userId: userId)
        } else {
            updatingFriendship = true
            friendsApolloRepository.updateFriendRequest(userId: userId, status: targetStatus)
                .receiveAndCancel { status in
                    self.loadProfile(userId)
                    debugPrint("friendsApolloRepository.updateFriendship, userId: \(userId)")
                } receiveError: { error in
                    print("updateFriendship Request Failed \(error)" )
                    self.updatingFriendship = false

                }
        }
    }
    
}

