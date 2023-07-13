//  GestureHandler.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 3/28/23.
//

import SwiftUI

final class StateManager: ObservableObject {
    @Published var currentUser: User?
    @Published var selectedUser: User?
    
    // update to shared state apollo repo
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
    
    func updateCurrentUser(user: User) {
        currentUser = user
        selectedUser = user
    }
}
