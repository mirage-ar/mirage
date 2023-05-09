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

    var body: some View {
        ZStack {
            Colors.black.swiftUIColor
                .edgesIgnoringSafeArea(.all)
                        
            VStack {
                Button {
                    print("Edit Image")
                } label: {
                    AsyncImage(url: URL(string: "https://i.pinimg.com/736x/73/6d/65/736d65181843edcf06c220cbf79933fb.jpg")) { image in
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
                .padding(.all, 50)
                
                VStack(alignment: .leading) {
                    VStack(spacing: 5) {
                        Text("UserName")
                            .font(Font.body)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)

                        Text("#2123123")
                            .font(Font.body)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Colors.white.swiftUIColor)
                    }
                    .onTapGesture {
                        gotoEditUserName = true
                    }
                    
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)
                    
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
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Bio")
                            .font(Font.body)
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                        
                        TextEditor(text: $bioText)
                            .foregroundColor(Colors.white.swiftUIColor)
                            .background(.clear)
                            .scrollContentBackground(.hidden)
                            .frame(maxHeight: 100)
                        
                    }
                    .onTapGesture {
                        gotoEditBio = true
                    }
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)

                    
                }
                Spacer()
                
                VStack {
                    Button {
                        
                    } label: {
                        Text("Signout")
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
        .navigationTitle("Edit Profile")
        .navigationDestination(isPresented: $gotoEditUserName) {
            NavigationRoute.updateUser(title: "USERNAME").screen
        }
        .navigationDestination(isPresented: $gotoEditBio) {
            NavigationRoute.updateUser(title: "BIO").screen
        }

    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
