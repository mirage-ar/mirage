//  StateManager.swift
//  Mirage Mira Creator
//
//  Created by fiigmnt on 3/28/23.
//

import SwiftUI

final class StateManager: ObservableObject {
    @Published var loggedInUser: User?
    @Published var selectedUserOnMap: User?
    @Published var isLoadingUserProfile = false
    
    // TODO: remove once we have realtime data
    @Published var temporaryAllMiras: [Mira] = []
    @Published var isScreenRecording = false

    let userProfileRepository: UserProfileApolloRepository = AppConfiguration.shared.apollo

    // TODO: update to state apollo repo
    let userApolloRepository: UserProfileApolloRepository = AppConfiguration.shared.apollo
    
    init() {
        if LocationManager.shared.location == nil {
            LocationManager.shared.requestLocation()
        }
        
        loadUser()
    }
    
    func loadUser() {
        // TODO: update to own repository
        userApolloRepository.getUser(id: UserDefaultsStorage().getString(for: .userId) ?? "")
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                self.loggedInUser = user
                UserDefaultsStorage().save(user)
                print("userProfileRepository.getUser, userId: \(user.id)")
                print(user.collectedMiraCount)
            } receiveError: { error in
                print("Get profile user error \(error)")
            }
    }
    
    func updateLoggedInUser(user: User) {
        DispatchQueue.main.async {
            self.loggedInUser = user
        }
        UserDefaultsStorage().save(user)
    }
    
    func updateMapSelectedUser(user: User) {
        DispatchQueue.main.async {
            self.selectedUserOnMap = user
        }
    }
}

//MARK:- User Profile Methods
extension StateManager {
    func uploadUserImage(_ image: UIImage) {
        DownloadManager.shared.upload(image: image) { [weak self] url in
            if let url = url, var user = UserDefaultsStorage().getUser() {
                user.profileImage = url
                self?.update(user: user)
                self?.updateLoggedInUser(user: user)
                self?.updateMapSelectedUser(user: user)
            }
        }
    }

    func update(user: User) {
        userProfileRepository.updateUser(user: user)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                UserDefaultsStorage().save(user)
            } receiveError: { error in
                print("UpdateUser profileimage error \(error)" )
            }
    }

}
