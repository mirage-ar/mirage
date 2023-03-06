//
//  UserTokenNetworkRepositery.swift
//  Mirage
//
//  Created by Saad on 06/03/2023.
//

import Foundation


public protocol UserTokenNetworkRepository {
    /// Updates user authentication token
    func updateUserToken(_ token: String)
}
