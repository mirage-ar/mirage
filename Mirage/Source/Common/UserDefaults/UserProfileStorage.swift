//
//  UserProfileStorage.swift
//  Mirage
//
//  Created by Saad on 07/07/2023.
//

import Foundation

protocol UserProfileStorage {
    
    func save(_ user: User?, property: UserProperty)
    
    func getUser(property: UserProperty) -> User?
}
