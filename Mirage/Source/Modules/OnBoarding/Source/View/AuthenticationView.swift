//
//  AuthenticationView.swift
//  Mirage
//
//  Created by Saad on 21/02/2023.
//

import SwiftUI
import iPhoneNumberField

struct AuthenticationView: View {
    @ObservedObject private var viewModel = AuthenticationViewModel()
    @State var phoneNumber: String
    @State var isEditing: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)

                VStack (alignment: .center, spacing: 10) {

                    Text("SIGN UP")
                        .foregroundColor(Colors.white.just)
                        .font(.subtitle1)
                        .padding()
                    Text("Your phone number is used to log in and won’t be vesible to others.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Colors.white.just)
                        .font(.body)
                        .padding()
                    
                    iPhoneNumberField("(000) 000-0000", text: $phoneNumber, isEditing: $isEditing)
                        .defaultRegion("US")
                        .placeholderColor(Colors.white.just)
                        .flagSelectable(false)
                        .flagHidden(false)
                        .maximumDigits(10)
                        .multilineTextAlignment(.leading)
                        .font(UIFont(size: 36, weight: .light, design: .monospaced))
                        .foregroundColor(Colors.white.just)
                        .clearButtonMode(.whileEditing)
                        .onClear { _ in isEditing.toggle() }
                        .border(Colors.white.just)
                        .navigationDestination(isPresented: $viewModel.authorizeSuccess) {
                            NavigationRoute.onboardingVerifyPhoneNumber(phoneNumer: phoneNumber).screen
                        }
                        .padding()

                    
                    Spacer()
                    Group {
                        if viewModel.isLoading {
                            ActivityIndicator(color: Colors.white.just, size: 50)
                        } else {
                            LargeButton(title: "DONE") {
                                viewModel.authorizeSuccess = true // temp for quick navigation
                                if phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                                    viewModel.authenticate(number: phoneNumber)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 5)

                }
                .padding(.top, 10
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accentColor(Colors.white.just)
            .background(Colors.black.just)
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                viewModel.isLoading = false
            }
        }
        .accentColor(Colors.white.swiftUIColor)

    }
}
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(phoneNumber: "", isEditing: false)
    }
}
