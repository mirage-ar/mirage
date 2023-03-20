//
//  UpdateUserView.swift
//  Mirage
//
//  Created by Saad on 15/03/2023.
//

import SwiftUI

struct UpdateUserView: View {
    @ObservedObject private var viewModel = AuthenticationViewModel()
    let accessToken: String
    let id: String
    @State var userName: String

    var body: some View {
        VStack (alignment: .center, spacing: 10) {
            Text("Choose a UserName!")
            TextField("Enter UserName", text: $userName)
                .multilineTextAlignment(.center)
            
            Button("Update") {
                guard !viewModel.isLoading, !userName.removedWhiteSpaces.isEmpty  else {
                    return
                }
                viewModel.authenticationRepository.updateUser(id: id, accessToken: accessToken, userName: userName)
            }
            .navigate(to: .onboardingAuthentication)
        }
    }
}
