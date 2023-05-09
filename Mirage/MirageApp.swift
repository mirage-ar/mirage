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
    }
    var body: some Scene {
        WindowGroup {
            AuthenticationView(phoneNumber: "", isEditing: false)
        }
    }
}
