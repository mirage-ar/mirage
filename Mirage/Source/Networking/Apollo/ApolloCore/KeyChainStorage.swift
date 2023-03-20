//
//  KeyChainStorage.swift
//  Mirage
//
//  Created by Saad on 06/03/2023.
//

import Foundation
import KeychainSwift

public protocol SecureStorage {
    /// Returns a string from a storage with a passed key
    func getString(with key: String) -> String?

    /// Saves a string to a storage with a passed key
    func save(_ value: String, for key: String)

    /// Deletes a string from a storage with a passed key
    func remove(key: String)
}


public struct KeychainStorage: SecureStorage {

    private let keychain = KeychainSwift()

    public init() { }

    /// Returns a string from Keychain with a passed key
    ///
    ///  - parameters:
    ///     - key: A key to retrieve a string with
    ///
    ///  - returns: An optional string
    ///
    public func getString(with key: String) -> String? {
        keychain.get(key)
    }

    /// Saves a string to Keychain with a passed key
    ///
    ///  - parameters:
    ///     - value: A string to be saved
    ///     - key: A key to save a string with
    ///
    public func save(_ value: String, for key: String) {
        keychain.set(value, forKey: key)
    }

    /// Deletes a string from Keychain with a passed key
    ///
    ///  - parameters:
    ///     - key: A key of a string to be deveted
    ///
    public func remove(key: String) {
        keychain.delete(key)
    }
}
