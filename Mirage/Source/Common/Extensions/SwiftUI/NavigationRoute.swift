//
//  NavigationRoute.swift
//  Mirage
//
//  Created by Saad on 15/03/2023.
//

import SwiftUI

public enum NavigationRoute {
    //MARK: OnBoarding
    case onboardingAuthentication
    case onboardingVerifyPhoneNumber(phoneNumer: String)
    case updateUser(title: String, value: String, user: User)
    case myProfile(userId: String)
    case settings(user: User)
    case editProfile(user: User)
    case miraCollectedByUsersList(mira: Binding<Mira?>, selectedUser: Binding<User?>)

    //MARK: Home
    case homeViewLanding
    case homeToARCameraView
    
    public var screen: some View {
        Group {
            switch self {
            case .onboardingAuthentication:
                AuthenticationView(phoneNumber: "", isEditing: false)
            case .onboardingVerifyPhoneNumber(let phoneNumer):
                VerifyPhoneNumberView(phoneNumber: phoneNumer, verificationCode: "")
            case .updateUser(let title, let value, let user):
                UpdateUserView(title: title, value: value, user: user)
            case .homeViewLanding:
                HomeView()
            case .homeToARCameraView:
                ARCameraView()
            case .myProfile(let userId):
                UserProfileView(userId: userId)
            case .settings(let user):
                SettingsView(user: user)
            case .editProfile(let user):
                EditProfileView(user: user)
            case .miraCollectedByUsersList(let mira, let selectedUser):
                CollectedByUsersView(selectedMira: mira, selectedUser: selectedUser)
            }
        }
    }
    
}
