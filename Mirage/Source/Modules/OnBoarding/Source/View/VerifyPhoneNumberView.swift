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
    @FocusState private var focusField: Int?

    
    var body: some View {
        ZStack {
            VStack (alignment: .center, spacing: 10) {
                Text("SING UP")
                    .foregroundColor(Colors.white.just)
                    .font(.subtitle1)
                    .padding()
                Text("Sent code to +1 \(phoneNumber)")
                    .foregroundColor(Colors.white.just)
                    .padding()
                
                HStack (alignment: .center, spacing: 20) {
                    ForEach((0...3), id: \.self) { id in
                        iPhoneNumberField("", text: $code[id])
                            .multilineTextAlignment(.leading)
                            .flagHidden(true)
                            .autofillPrefix(false)
                            .defaultRegion("UK") //to accept all numbers
                            .maximumDigits(1)
                            .multilineTextAlignment(.center)
                            .formatted(true)
                            .onEdit{ number in
                                if number.text?.count == 1 {
                                    focusNextField(from: id)
                                }
                            }
                            .font(UIFont(size: 36, weight: .light, design: .monospaced))
                            .foregroundColor(Colors.white.just)
                            .border(Colors.white.just)
                            .frame(width: 50, height: 50)
                            .focused($focusField, equals: id)
                    }
                }
                
                Spacer()
                Group {
                    if viewModel.isLoading {
                        ActivityIndicator(color: Colors.white.just, size: 50)
                    } else {
                        LargeButton(title: "DONE") {
                            if code.joined().count == 4 {
                                viewModel.verifyUser(number: phoneNumber, code: code.joined())
                            } else {
                                viewModel.verifyUserSuccess = true // temp for quick navigation
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $viewModel.verifyUserSuccess) {
                    NavigationRoute.homeViewLanding.screen
                }
                .padding(.bottom, 5)
                
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accentColor(Colors.white.just)
        .background(Colors.black.just)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusField = 0
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
    private func focusNextField(from index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            focusField = index + 1
        }
    }

    
}

