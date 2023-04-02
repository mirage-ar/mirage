//
//  VerifyPhoneNumberView.swift
//  Mirage
//
//  Created by Saad on 15/03/2023.
//

import SwiftUI
import iPhoneNumberField

struct VerifyPhoneNumberView: View {
    @ObservedObject private var viewModel = AuthenticationViewModel()
    let phoneNumber: String
    @State var verificationCode: String
    @State var code: [String] = Array(repeating: "", count: 4)
    
    var body: some View {
        ZStack {
            VStack (alignment: .center, spacing: 10) {
                Text("Sign Up!")
                    .foregroundColor(Colors.white.just)
                    .padding()
                Text("Sent code to +1 \(phoneNumber)")
                    .foregroundColor(Colors.white.just)
                    .padding()
                
                HStack (alignment: .center, spacing: 20) {
                    ForEach((0...3), id: \.self) { id in
                        iPhoneNumberField("", text: $code[id])
                            .multilineTextAlignment(.leading)
                            .flagHidden(true)
                            .maximumDigits(1)
                            .multilineTextAlignment(.center)
                            .font(UIFont(size: 30, weight: .light, design: .monospaced))
                            .foregroundColor(Colors.white.just)
                            .border(Colors.white.just)
                            .frame(width: 50, height: 50)
                    }
                }
                
                Spacer()
                Group {
                    if viewModel.isLoading {
                        ActivityIndicator(color: Colors.white.just, size: 50)
                    } else {
                        LargeButton(title: "Done") {
                            if code.joined().count == 4 {
                                viewModel.verifyUser(number: phoneNumber, code: code.joined())
                            }
                        }
                    }
                }
                .navigationDestination(isPresented: $viewModel.verifyUserSuccess) {
                    NavigationRoute.homeViewLanding.screen
                }
                .padding(.bottom, 50)
                
            }
            .padding(.top, 50)
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accentColor(Colors.white.just)
        .background(Colors.black.just)
        .onTapGesture {
            hideKeyboard()
        }
    }
    
}

