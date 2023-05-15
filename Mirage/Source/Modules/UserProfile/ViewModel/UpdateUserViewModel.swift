//
//  UpdateUserViewModel.swift
//  Mirage
//
//  Created by Saad on 15/05/2023.
//

import Foundation

final class UpdateUserViewModel: ObservableObject {
    let userProfileRepository: UserProfileApolloRepository = AppConfiguration.shared.apollo
    @Published var user = User()
    @Published var isLoading = false
    @Published var userUpdated = false
    
    func update(user: User) {
        isLoading = true
        userProfileRepository.updateUser(user: user)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel { user in
                self.user = user
                self.userUpdated = true
                self.isLoading = false
            } receiveError: { error in
                self.isLoading = false
                print("Get profile user error \(error)" )
            }
    }
}
