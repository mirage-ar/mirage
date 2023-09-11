//
//  UserProfileViewModel.swift
//  Mirage
//
//  Created by Saad on 04/05/2023.
//

import Foundation
import Combine

final class UserProfileViewModel: ObservableObject {
    @Published var user: User?
    
    let userProfileRepository: UserProfileApolloRepository = AppConfiguration.shared.apollo
    
    func loadProfile(_ userId: String) {
        userProfileRepository.getUser(id: userId)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                self.user = user
                print("userProfileRepository.getUser, userId: \(user.id)")
            } receiveError: { error in
                print("Get profile user error \(error)" )
            }
    }
}

