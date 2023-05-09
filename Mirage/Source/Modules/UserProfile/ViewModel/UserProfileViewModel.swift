//
//  UserProfileViewModel.swift
//  Mirage
//
//  Created by Saad on 04/05/2023.
//

import Foundation

final class UserProfileViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var hasLoadedProfile = false
    

    init() {
    }

}
