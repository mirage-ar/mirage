//
//  UserProfileViewModel.swift
//  Mirage
//
//  Created by Saad on 04/05/2023.
//

import Foundation
import Combine

final class UserProfileViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var user = User()
    
    let userProfileRepository: UserProfileApolloRepository = AppConfiguration.shared.apollo


    init(userId: String) {
        loadProfile(userId)
        print("loadProfile, userId: \(userId)")
    }
    
    func loadProfile(_ userId: String) {
        if LocationManager.shared.location == nil {
            LocationManager.shared.requestLocation()
        }
        
        // TODO: update accessToken to stored value
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

