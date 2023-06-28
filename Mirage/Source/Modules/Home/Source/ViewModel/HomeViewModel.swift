//
//  HomeViewModel.swift
//  Mirage
//
//  Created by Saad on 20/04/2023.
//

import Foundation
final class HomeViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var currentUser: User?

    let homeApolloRepository: HomeApolloRepository = AppConfiguration.shared.apollo

    init() {
        if LocationManager.shared.location == nil {
            LocationManager.shared.requestLocation()
        }

        loadUser()
    }

    func loadUser() {
        homeApolloRepository.getUser()
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                self.currentUser = user
                print("userProfileRepository.getUser, userId: \(user.id)")
            } receiveError: { error in
                print("Get profile user error \(error)")
            }
    }
    
}
