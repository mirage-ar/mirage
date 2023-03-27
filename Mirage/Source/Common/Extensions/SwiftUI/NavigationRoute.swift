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
    case onboardingUpdateUser(id: String, accessToken: String)

    //MARK: Home
    case homeViewLanding

    public var screen: some View {
        Group {
            switch self {
            case .onboardingAuthentication:
                AuthenticationView(phoneNumber: "", isEditing: false)
            case .onboardingVerifyPhoneNumber(let phoneNumer):
                VerifyPhoneNumberView(phoneNumber: phoneNumer, verificationCode: "")
            case .onboardingUpdateUser(let id, let accessToken):
                UpdateUserView(accessToken: accessToken, id: id, userName: "")
            case .homeViewLanding:
                HomeView()
            }
        }
    }
    
}
