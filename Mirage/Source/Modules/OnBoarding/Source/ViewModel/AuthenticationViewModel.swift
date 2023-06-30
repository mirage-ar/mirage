//
//  AuthenticationViewModel.swift
//  Mirage
//
//  Created by Saad on 21/02/2023.
//

import Foundation
import Combine


final class AuthenticationViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var sid: String? = ""
    @Published var authorizeSuccess = false
    @Published var verifyUserSuccess = false

    let authenticationRepository: AuthenticationRepository = AppConfiguration.shared.apollo
    
    func authenticate(number: String) {
        authenticationRepository.authenticate(number: number)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel (receiveOutput: { accountStage in
                debugPrint("Account Stage: \(accountStage)")
                self.isLoading = false
                if accountStage == MirageAPI.AccountStage.new.rawValue || accountStage == MirageAPI.AccountStage.new.rawValue {
                    self.authorizeSuccess = true
                }
            }, receiveError: { error in
                print("Error: \(error)")
            })
    
        
        isLoading = true
        
    }
    
    func verifyUser(number: String, code: String) {
        authenticationRepository.verifyUser(number: number, code: code)
            .receive(on: DispatchQueue.main)
            .receiveAndCancel (receiveOutput: {
                debugPrint("ID: \($0?.id ?? UUID()) access token: " + ($1 ?? ""))
                if $0 != nil && $1?.isEmpty == false {
                    self.verifyUserSuccess = true
                }
                self.isLoading = false
            }, receiveError: { error in
                print("Error: \(error)")
            })
        
        isLoading = true
        
    }

}
