//
//  AuthenticationViewModel.swift
//  Mirage
//
//  Created by Saad on 21/02/2023.
//

import Foundation

final class AuthenticationViewModel: ObservableObject {
    @Published var isLoading = false
    
    func authenticate(number: String) {
        isLoading = true
    }
}
