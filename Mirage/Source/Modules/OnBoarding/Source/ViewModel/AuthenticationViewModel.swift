//
//  AuthenticationViewModel.swift
//  Mirage
//
//  Created by Saad on 21/02/2023.
//

import Foundation
import Combine


final class AuthenticationViewModel: ObservableObject {
    var isLoading = false
    @Published var sid: String? = ""
    
    let authenticationRepository: AuthenticationRepository = AppConfiguration.shared.apollo
    func authenticate(number: String) {
        authenticationRepository.authenticate(number: number)
            .receiveAndCancel (receiveOutput: { sid in
                print("Verficatino ID" + sid)
                
                DispatchQueue.main.async {
                    self.sid = sid
                }
                self.isLoading = false
            })
        
        isLoading = true
        
    }
    
    func verifyUser(number: String, code: String) {
        authenticationRepository.verifyUser(number: number, code: code)
            .receiveAndCancel (receiveOutput: {
                print("ID" + $0 + " access token: " + $1)
//                DispatchQueue.main.async {
//                    self.sid = sid
//                }
                self.isLoading = false
            })
        
        isLoading = true
        
    }

}
