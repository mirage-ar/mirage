//
//  UpdateUserView.swift
//  Mirage
//
//  Created by Saad on 15/03/2023.
//

import SwiftUI

struct UpdateUserView: View {
    @ObservedObject private var viewModel = AuthenticationViewModel()
    let title: String
    @State var value: String

    var body: some View {
        ZStack {
            Colors.black.swiftUIColor
                .edgesIgnoringSafeArea(.all)
            
        }
        VStack {
            if title == "BIO" {
                TextEditor(text: $value)
                    .foregroundColor(Colors.white.swiftUIColor)
                    .background(.clear)
                    .scrollContentBackground(.hidden)
                    .frame(maxHeight: 100)

            } else {
                TextField("Enter UserName", text: $value)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Colors.white.swiftUIColor)
            }
            
            Divider()
                .overlay(Colors.g4LightGrey.swiftUIColor)
            
            Spacer()
            
            Group {
                if viewModel.isLoading {
                    ActivityIndicator(color: Colors.white.just, size: 50)
                } else {
                    LargeButton(title: "Done") {
                        
                    }
                }
            }
            .padding(.bottom, 50)
        }
    }
}
