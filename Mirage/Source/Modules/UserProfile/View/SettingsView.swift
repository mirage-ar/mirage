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
                        Text("CONTACT US")
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
                        openInstagramPage()
                    } label: {
                        Text("Instagram")
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                    }

                    Button {
                        print("Twitter")
                        openTwitterPage()
                    } label: {
                        Text("Twitter")
                            .foregroundColor(Colors.g4LightGrey.swiftUIColor)
                    }
                    
                    Button {
                        print("Terms and Privacy Policy")
                        openPrivacyPolicy()
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
        .navigationTitle("SETTINGS")
        .accentColor(Colors.white.swiftUIColor)
        .navigationDestination(isPresented: $showEditProfile) {
            NavigationRoute.editProfile(user: user).screen
        }
    }
    
    private func openPrivacyPolicy() {
        let webUrl = "http://www.twitter.com/thismirage"
        openAppUrl(appUrl: "nan", webUrl: webUrl)
    }
    
    private func openTwitterPage() {
        let appUrl = "twitter://user?screen_name=thismirage"
        let webUrl = "http://www.twitter.com/thismirage"
        openAppUrl(appUrl: appUrl, webUrl: webUrl)
    }
    private func openInstagramPage() {
        let appUrl = "instagram://user?username=mirage.ar_"
        let webUrl = "https://instagram.com/mirage.ar_"
        openAppUrl(appUrl: appUrl, webUrl: webUrl)
    }
    private func openAppUrl(appUrl: String, webUrl: String) {
        guard let appURL = URL(string: appUrl) else { return }
        
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            guard let webURL = URL(string: webUrl) else { return }
            application.open(webURL)
        }
    }

}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(user: .dummy)
    }
}
