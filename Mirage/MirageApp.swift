//
//  MirageApp.swift
//  Mirage
//
//  Created by fiigmnt on 1/9/23.
//

import SwiftUI

@main
struct MirageApp: App {
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: Colors.white.color]
        navBarAppearance.titleTextAttributes = [.foregroundColor: Colors.white.color]
        navBarAppearance.isTranslucent = true
        navBarAppearance.tintColor = .clear
        navBarAppearance.backgroundColor = .clear
    }
    var body: some Scene {
        WindowGroup {
            if let _ = DefaultUserTokenService().getAccessToken() {
                HomeView(selectedMira: .dummy)
            } else {
                AuthenticationView(phoneNumber: "", isEditing: false)
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
