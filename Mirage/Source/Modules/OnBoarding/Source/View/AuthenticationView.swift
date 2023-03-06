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
        Text("Login with your Number!")
        TextField("Enter Number", text: $phoneNumber)
        Button("Login") {
            guard !viewModel.isLoading, !phoneNumber.removedWhiteSpaces.isEmpty  else {
                return
            }
            viewModel.authenticate(number: phoneNumber)
        }
    }
}
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(phoneNumber: "")
    }
}
