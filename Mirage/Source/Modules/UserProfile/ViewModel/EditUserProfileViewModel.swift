//
//  EditUserProfileViewModel.swift
//  Mirage
//
//  Created by Saad on 12/05/2023.
//

import Foundation
import Combine

final class EditUserProfileViewModel: ObservableObject {
    let userProfileRepository: UserProfileApolloRepository = AppConfiguration.shared.apollo

    func signoutUser() {
        UserDefaultsStorage().clearAllUserSpecificProperties()
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
