//
//  UserDefaultsStorage.swift
//  Mirage
//
//  Created by Saad on 23/05/2023.
//

import Foundation

public struct UserDefaultsStorage: UserPropertiesStorage {
    public init() { }

    // MARK: - Bool manipulations

    /// Retrieves a bool from UserDefaults
    ///
    ///  - parameters:
    ///     - property: A property to retrieve the bool for
    ///
    /// - returns: A bool or nil if it's not been found
    ///
    public func getBool(for property: UserProperty) -> Bool {
        UserDefaults.standard.bool(forKey: property.key)
    }

    /// Saves a bool to UserDefaults
    ///
    ///  - parameters:
    ///     - bool: A bool to be saved
    ///     - property: A property to save the bool for
    ///
    public func save(_ bool: Bool?, for property: UserProperty) {
        if let val = bool {
            UserDefaults.standard.set(val, forKey: property.key)
        } else {
            clear(property: property)
        }
    }

    // MARK: - Strings manipulations

    /// Retrieves a string from UserDefaults
    ///
    ///  - parameters:
    ///     - property: A property to retrieve the string for
    ///
    /// - returns: A string or nil if it's not been found
    ///
    public func getString(for property: UserProperty) -> String? {
        UserDefaults.standard.string(forKey: property.key)
    }

    /// Saves a string to UserDefaults
    ///
    ///  - parameters:
    ///     - string: A string to be saved
    ///     - property: A property to save the string for
    ///
    public func save(_ string: String?, for property: UserProperty) {
        if let val = string {
            UserDefaults.standard.set(val, forKey: property.key)
        } else {
            clear(property: property)
        }
    }
/*
    // MARK: - Date manipulations

    /// Retrieves a date from UserDefaults
    ///
    ///  - parameters:
    ///     - property: A property to retrieve the date for
    ///
    /// - returns: A date or nil if it's not been found
    ///
    public func getDate(for property: UserProperty) -> Date? {
        guard let formattedDateString = getString(for: property) else {
            return nil
        }

        return formattedDateString.date(from: .dateStorageFormat)
    }

    /// Saves a date to UserDefaults
    ///
    ///  - parameters:
    ///     - date: A date to be saved
    ///     - property: A property to save the date for
    ///
    public func save(_ date: Date, for property: UserProperty) {
        let formattedDateString = date.formatted(.dateStorageFormat)

        save(formattedDateString, for: property)
    }
*/
    // MARK: - Clear

    /// Removes passed property from a properties storage
    ///
    ///  - parameters:
    ///     - property: Property to be removed
    ///
    public func clear(property: UserProperty) {
        UserDefaults.standard.removeObject(forKey: property.key)
    }

    /// Removes passed properties from UserDefaults
    ///
    ///  - parameters:
    ///     - properties: Properties to be removed
    ///
    public func clear(properties: [UserProperty]) {
        properties.forEach {
            UserDefaults.standard.removeObject(forKey: $0.key)
        }
    }

    /// Removes all user specofoc `UserProperty` cases from a properties storage
    public func clearAllUserSpecificProperties() {
        let userSpecificProperties = UserProperty.allCases.filter { $0.isUserSpecific }

        clear(properties: userSpecificProperties)
    }

    /// Removes all `UserProperty` cases from UserDefaults
    public func clearAll() {
        clear(properties: UserProperty.allCases)
    }
}

