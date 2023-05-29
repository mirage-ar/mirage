//
//  EditProfileView.swift
//  Mirage
//
//  Created by Saad on 09/05/2023.
//

import SwiftUI

struct EditProfileView: View {
    @State var bioText = "Ny Based CG Artist\ninst: @xyz\nMusic Lover\nAthlete"
    @State var gotoEditUserName = false
    @State var gotoEditBio = false
    @State var user: User
    @ObservedObject private var viewModel = EditUserProfileViewModel()

    
    var body: some View {
        ZStack {
            Colors.black.swiftUIColor
                .edgesIgnoringSafeArea(.all)
                        
            VStack {
                ZStack {
                    Button {
                        print("Edit Image")
                    } label: {
                        AsyncImage(url: URL(string: user.profileImage)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                                .foregroundColor(Colors.white8p.swiftUIColor)
                        }
                        .frame(width: 150, height: 150)
                        .cornerRadius(75)
                        .clipped()

                    }
                    Images.refresh.swiftUIImage
                        .padding(.top, 150)
                    
                }
                .padding(.all, 50)
               
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("UserName")
                                .font(Font.body)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                            Spacer()

                        }
                        HStack {
                            Text(user.userName ?? "")
                                .font(Font.body)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Colors.white.swiftUIColor)
                            Spacer()
                        }
                        .padding(.leading, 5)

                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        gotoEditUserName = true
                    }
                    
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)
                    
                    //Temporarily Hidden for MPV Version
                    /*
                    VStack(spacing: 5) {
                        Text("Pronouns")
                            .font(Font.body)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                        
                        Text("She/They")
                            .font(Font.body)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Colors.white.swiftUIColor)
                        
                    }
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)
                    */
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Bio")
                            .font(.body)
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                        
                        TextEditor(text: $bioText)
                            .foregroundColor(Colors.white.swiftUIColor)
                            .background(.clear)
                            .scrollContentBackground(.hidden)
                            .frame(maxHeight: 100)
                        
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        gotoEditBio = true
                    }
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)

                    
                }
                Spacer()
                
                VStack {
                    Button {
                        viewModel.signoutUser()
                    } label: {
                        Text("SIGNOUT")
                            .font(Font.body)
                            .foregroundColor(Colors.white.swiftUIColor)
                    }
                    
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)

                    Button {
                        
                    } label: {
                        Text("DELETE ACCOUNT")
                            .font(Font.body)
                            .foregroundColor(Colors.red.swiftUIColor)
                    }

                    
                }

            }

            
        }
        .onAppear() {
            bioText = user.bio ?? ""
        }
        .navigationTitle("EDIT PRPFILE")
        .navigationDestination(isPresented: $gotoEditUserName) {
            NavigationRoute.updateUser(title: "USERNAME", value: user.userName ?? "", user: user).screen
        }
        .navigationDestination(isPresented: $gotoEditBio) {
            NavigationRoute.updateUser(title: "BIO", value: user.bio ?? "", user: user).screen
        }

    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: .dummyUser())
    }
}
