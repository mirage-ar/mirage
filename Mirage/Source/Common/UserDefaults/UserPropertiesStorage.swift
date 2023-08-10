//
//  UserPropertiesStorage.swift
//  Mirage
//
//  Created by Saad on 23/05/2023.
//

import Foundation

public protocol UserPropertiesStorage {
    /// Retrieves a bool from UserDefaults
    func getBool(for property: UserProperty) -> Bool

    /// Saves a bool to UserDefaults
    func save(_ bool: Bool?, for property: UserProperty)

    /// Retrieves a string from UserDefaults
    func getString(for property: UserProperty) -> String?

    /// Saves a string to UserDefaults
    func save(_ string: String?, for property: UserProperty)

    /// Retrieves a date from a properties storage
//    func getDate(for property: UserProperty) -> Date?

    /// Saves a date to a properties storage
//    func save(_ date: Date, for property: UserProperty)

    /// Removes passed property from a properties storage
    func clear(property: UserProperty)

    /// Removes passed properties from a properties storage
    func clear(properties: [UserProperty])

    /// Removes all user specofoc `UserProperty` cases from a properties storage
    func clearAllUserSpecificProperties()

    /// Removes all `UserProperty` cases from a properties storage
    func clearAll()
}

public enum UserProperty: String, CaseIterable {
    
    case userId
    case accessToken
    case userProfile
    case getStartedLaunched

    public var isUserSpecific: Bool {
        switch self {
            case .getStartedLaunched:
            return true//clear this at signout as well
            default: return true
        }
    }
    
    var key: String {
        return self.rawValue
    }

}
