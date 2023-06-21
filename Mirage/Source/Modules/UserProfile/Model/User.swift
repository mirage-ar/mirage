//
//  User.swift
//  Mirage
//
//  Created by Saad on 05/05/2023.
//

import Foundation

public struct User {
    let id: String
    let profileImage: String
    let profileImageDesaturated: String
    let userName: String?
    let profileDescription: String?
    
    init(id: String, profileImage: String, profileImageDesaturated: String, userName: String?, bio: String?) {
        self.id = id
        self.profileImage = profileImage
        self.profileImageDesaturated = profileImageDesaturated
        self.userName = userName
        self.profileDescription = bio
    }
    
    init() {
        self.id = ""
        self.profileImage = ""
        self.profileImageDesaturated = ""
        self.userName = nil
        self.profileDescription = nil
    }
    //    init(id: String, profileImage: String, profileImageDesaturated: String, userName: String) {
    //        self.id = id
    //        self.profileImage = profileImage
    //        self.profileImageDesaturated = profileImageDesaturated
    //        self.userName = userName
    //    }
    //    init(creator: MirageAPI.GetMirasQuery.Data.GetMira.Creator?) {
    //
    //        id = creator?.id ?? "0"
    //        profileImage = creator?.profileImage ?? colorImages[Int.random(in: 0..<colorImages.count)]
    //        userName = creator?.username ?? ""
    //        profileImageDesaturated = creator?.profileImageDesaturated ?? blackImages[Int.random(in: 0..<blackImages.count)]
    //    }
}

//MARK: - API Translators
extension User {

    init(apiUser: MirageAPI.UserQuery.Data.User?) {
        
        id = apiUser?.id ?? "0"
        profileImage = apiUser?.profileImage ?? colorImages[Int.random(in: 0..<colorImages.count)]
        userName = apiUser?.username ?? ""
        profileImageDesaturated = apiUser?.profileImageDesaturated ?? blackImages[Int.random(in: 0..<blackImages.count)]
        profileDescription = "Dummy Bio"
    }
    func updated(apiUpdatedUser: MirageAPI.UpdateUserMutation.Data.UpdateUser?) -> User {
        
        return User(id: id, profileImage: profileImage, profileImageDesaturated: profileImageDesaturated, userName: apiUpdatedUser?.username ?? "" , bio: apiUpdatedUser?.username ?? "")
    }

}

//MARK: - Dereive Properties
extension User {
    var isDescriptionEmpty: Bool {
        return !(self.profileDescription?.isEmpty == true || self.userName?.isEmpty == true)
    }
    static func dummyUser() -> User {
        return User(id: "1", profileImage: "", profileImageDesaturated: "", userName: "NaN", bio: "")
    }
}
