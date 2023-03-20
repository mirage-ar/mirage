//
//  VerifyPhoneNumberView.swift
//  Mirage
//
//  Created by Saad on 15/03/2023.
//

import Foundation
import SwiftUI

struct VerifyPhoneNumberView: View {
    @ObservedObject private var viewModel = AuthenticationViewModel()
    let phoneNumber: String
    @State var verificationCode: String

    var body: some View {
        VStack (alignment: .center, spacing: 10) {
            Text("Enter Verification Code!")
            TextField("Enter Code", text: $verificationCode)
                .multilineTextAlignment(.center)
            
            Button("Verify") {
                guard !viewModel.isLoading, !verificationCode.removedWhiteSpaces.isEmpty  else {
                    return
                }
                viewModel.verifyUser(number: phoneNumber, code: verificationCode)
            }
            .navigate(to: .onboardingUpdateUser(id: "", accessToken: ""))
        }
    }
}
