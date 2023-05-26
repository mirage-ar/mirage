//
//  SettingsView.swift
//  Mirage
//
//  Created by Saad on 09/05/2023.
//

import SwiftUI

struct SettingsView: View {
    @State var showEditProfile = false
    @State var user: User
    
    var body: some View {
        ZStack {
            Colors.black.swiftUIColor
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 15) {
                    
                    HStack {
                        Images.profile48.swiftUIImage
                        Text(user.userName ?? "NaN")
                            .font(Font.body)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Colors.white.swiftUIColor)
                        Spacer()
                        Images.arrowR24.swiftUIImage
                        
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showEditProfile = true
                    }
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)
                    
                    HStack {
                        Images.contactUs48.swiftUIImage
                        Text("Contact Us")
                            .font(Font.body)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Colors.white.swiftUIColor)
                        
                    }
                    Divider()
                        .overlay(Colors.g4LightGrey.swiftUIColor)

                    
                }
                VStack (alignment: .center, spacing: 15) {
                    Button {
                        print("Instagram")
                    } label: {
                        Text("Instagram")
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                    }

                    Button {
                        print("Twitter")
                    } label: {
                        Text("Twitter")
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                    }
                    
                    Button {
                        print("Terms and Privacy Policy")
                    } label: {
                        Text("Terms and Privacy Policy")
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                    }
                    Spacer()
                    //Temporarily Hidden for MVP version
                    /*
                    ZStack {
                        Colors.green.swiftUIColor
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            Text("Invite to Mirage")
                            Text("5 Invites")
                                .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                                .padding(.bottom, 5)
                        }
                    }
                    .frame(maxHeight: 60)
                     */
                }
            }
            .padding(.top, 50)
        }
        .navigationTitle("Settings")
        .accentColor(Colors.white.swiftUIColor)
        .navigationDestination(isPresented: $showEditProfile) {
            NavigationRoute.editProfile(user: user).screen
        }

    

    }
    
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(user: User.dummyUser())
    }
}
