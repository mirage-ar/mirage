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

    init(userId: UUID, user: User? = nil, hasLoadedProfile: Bool = false) {
        self.userId = userId
        self.user = user
        self.hasLoadedProfile = hasLoadedProfile
        loadProfile(userId)
    }
    
    let userProfileRepository: UserProfileApolloRepository = AppConfiguration.shared.apollo
    
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
}

