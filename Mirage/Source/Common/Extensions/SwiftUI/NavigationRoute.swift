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
    case profile(userId: UUID)
    case settings(user: User)
    case editProfile(user: User)
    case miraCollectedByUsersList(mira: Binding<Mira?>, selectedUserAction: ((User?) -> Void))
    case friendsListView(user: User)
    case sentRequestsView(user: User)

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
                ARViewCamera()
            case .profile(let userId):
                let loggedInUserId = UserDefaultsStorage().getString(for: .userId) ?? ""
                if userId == UUID(uuidString: loggedInUserId) {
                    MyProfileView(userId: userId)
                } else {
                    UserProfileView(userId: userId)
                }
            case .settings(let user):
                SettingsView(user: user)
            case .editProfile(let user):
                EditProfileView(user: user)
            case .miraCollectedByUsersList(let mira, let selectedUserAction):
                CollectedByUsersView(selectedMira: mira, selectedUserAction: selectedUserAction)
            case .friendsListView(let user):
                let loggedInUserId = UserDefaultsStorage().getString(for: .userId) ?? ""
                if user.id == UUID(uuidString: loggedInUserId) {
                    MyFriendsListView(user: user)
                } else {
                    UserFriendsListView(user: user)
                }
            case .sentRequestsView(let user):
                SentRequestsListView(user: user)
            }
        }
    }
    
}
