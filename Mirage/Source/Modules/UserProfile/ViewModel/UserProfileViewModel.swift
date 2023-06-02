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


    init() {
        loadProfile()
    }
    func loadProfile() {
        if LocationManager.shared.location == nil {
            LocationManager.shared.requestLocation()
        }
        print(LocationManager.shared.location)
        userProfileRepository.getUser(id: "1", accessToken: "1")
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                self.user = user
            } receiveError: { error in
                print("Get profile user error \(error)" )
            }
    }
}

