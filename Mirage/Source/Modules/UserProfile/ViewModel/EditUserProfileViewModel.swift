//
//  EditUserProfileViewModel.swift
//  Mirage
//
//  Created by Saad on 12/05/2023.
//

import Foundation
import Combine

final class EditUserProfileViewModel: ObservableObject {
    
    func signoutUser() {
        UserDefaultsStorage().clearAllUserSpecificProperties()
    }
}
