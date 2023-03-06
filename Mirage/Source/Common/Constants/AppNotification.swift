//
//  AppNotification.swift
//  Mirage
//
//  Created by Saad on 06/03/2023.
//

import Foundation


public extension Notification.Name {
    /// An event that the app was opened
    static var appOpened = Notification.Name("appOpened")

    /// An event that the app has returned from the background to foreground
    static var appRestoredFromBackground = Notification.Name("appRestoredFromBackground")

    /// An event that the app was minimised and went to the background
    static var appEnteredBackground = Notification.Name("appEnteredBackground")

    /// An event informs that selected tab in the main custom tab view was changed
    static var selectedTabChanged = Notification.Name("tabBarSelectedTabChanged")
}
