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
    case updateUser(title: String)
    case myProfile
    case settings
    case editProfile(user: User)
    
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
            case .updateUser(let title):
                UpdateUserView(title: title, value: "")
            case .homeViewLanding:
                HomeView()
            case .homeToARCameraView:
                ARCameraView()
            case .myProfile:
                UserProfileView()
            case .settings:
                SettingsView()
            case .editProfile(let user):
                EditProfileView(user: user)
                
            }
        }
    }
    
}
