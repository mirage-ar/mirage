//
//  MirageApp.swift
//  Mirage
//
//  Created by fiigmnt on 1/9/23.
//

import SwiftUI

@main
struct MirageApp: App {
    @ObservedObject private var appConfiguration: AppConfiguration
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Colors.white.color]
        navBarAppearance.titleTextAttributes = [.foregroundColor: Colors.white.color]
        navBarAppearance.isTranslucent = true
        navBarAppearance.tintColor = .clear
        navBarAppearance.backgroundColor = .clear
        appConfiguration = AppConfiguration.shared
    }
    var body: some Scene {
        WindowGroup {
            if appConfiguration.authentication {
                HomeView()
                    .environmentObject(StateManager())
            } else if appConfiguration.getStartedLaunched {
                AuthenticationView(phoneNumber: "", isEditing: false)
            } else {
                WelcomeView()
            }
        }
    }
}
extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
