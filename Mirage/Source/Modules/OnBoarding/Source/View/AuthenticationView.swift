//
//  AuthenticationView.swift
//  Mirage
//
//  Created by Saad on 21/02/2023.
//

import SwiftUI

struct AuthenticationView: View {
    @ObservedObject private var viewModel = AuthenticationViewModel()
    @State var phoneNumber: String
    
    var body: some View {
        VStack (alignment: .center, spacing: 10) {
            Text("Login with your Number!")
            TextField("Enter Number", text: $phoneNumber)
                .multilineTextAlignment(.center)
                
            Button("Login") {
                guard !viewModel.isLoading, !phoneNumber.removedWhiteSpaces.isEmpty  else {
                    return
                }
                viewModel.authenticate(number: phoneNumber)
                if let sid = viewModel.sid {
                    //push code verification
                }
            }
//            .navigate(to: .onboardingVerifyPhoneNumber(phoneNumer: viewModel.sid ?? ""))
        
        }
    }
}
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(phoneNumber: "")
    }
}
