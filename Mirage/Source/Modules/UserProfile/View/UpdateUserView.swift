//
//  UpdateUserView.swift
//  Mirage
//
//  Created by Saad on 15/03/2023.
//

import SwiftUI

struct UpdateUserView: View {
    @ObservedObject private var viewModel = UpdateUserViewModel()
    let title: String
    @State var value: String
    let user: User
    var userToBeUpdated: User {
        
        if title == "BIO" {
            return User(id: user.id, profileImage: user.profileImage, profileImageDesaturated: user.profileImageDesaturated, userName: user.userName, profileDescription: value)
        } else {
            return User(id: user.id, profileImage: user.profileImage, profileImageDesaturated: user.profileImageDesaturated, userName: value, profileDescription: user.profileDescription)
        }
    }
    var body: some View {
        ZStack {
            Colors.black.swiftUIColor
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if title.uppercased() == "BIO" {
                    TextEditor(text: $value)
                        .foregroundColor(Colors.white.swiftUIColor)
                        .background(.clear)
                        .scrollContentBackground(.hidden)
                        .frame(maxHeight: 100)
                    
                } else {
                    TextField("Enter UserName", text: $value)
                        .font(.title)
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
                            viewModel.update(user: userToBeUpdated)
                        }
                    }
                }
                .padding(.bottom, 50)
            }
            .padding(.top, 30)
        }
        .navigationTitle(title.uppercased())
        .navigationDestination(isPresented: $viewModel.userUpdated) {
            NavigationRoute.editProfile(user: .dummy).screen
        }

    }
    
}
