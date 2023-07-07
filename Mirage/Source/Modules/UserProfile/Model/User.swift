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

    
    init(id: String, profileImage: String, profileImageDesaturated: String, userName: String?, profileDescription: String?) {
        self.id = id
        self.profileImage = profileImage
        self.profileImageDesaturated = profileImageDesaturated
        self.userName = userName
        self.profileDescription = profileDescription
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
        profileDescription = apiUser?.profileDescription
    }
    init(verifyUser: MirageAPI.VerifyUserMutation.Data.VerifyUser.User) {
        id = verifyUser.id
        profileImage = verifyUser.profileImage ?? ""
        userName = verifyUser.username
        profileImageDesaturated = verifyUser.profileImageDesaturated ?? ""
        profileDescription = verifyUser.profileDescription
    }
    func updated(apiUpdatedUser: MirageAPI.UpdateUserMutation.Data.UpdateUser?) -> User {
        
        return User(id: id, profileImage: profileImage, profileImageDesaturated: profileImageDesaturated, userName: apiUpdatedUser?.username ?? "" , profileDescription: apiUpdatedUser?.username ?? "")
    }
    
    init(creator: MirageAPI.GetMirasQuery.Data.GetMira.Creator?) {
        id = creator?.id ?? "0"
        profileImage = creator?.profileImage ?? colorImages[Int.random(in: 0..<colorImages.count)]
        userName = creator?.username ?? ""
        profileImageDesaturated = creator?.profileImageDesaturated ?? blackImages[Int.random(in: 0..<blackImages.count)]
        profileDescription = creator?.profileDescription

    }
    
    init(collector: MirageAPI.GetMirasQuery.Data.GetMira.Collector?) {
        id = collector?.id ?? "0"
        profileImage = collector?.profileImage ?? colorImages[Int.random(in: 0..<colorImages.count)]
        userName = collector?.username ?? ""
        profileImageDesaturated = collector?.profileImageDesaturated ?? blackImages[Int.random(in: 0..<blackImages.count)]
        profileDescription = collector?.profileDescription
    }


}
//MARK: - Hashable
extension User: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
//MARK: - Dereive Properties
extension User {
    var isDescriptionEmpty: Bool {
        return !(self.profileDescription?.isEmpty == true || self.userName?.isEmpty == true)
    }
    static var dummy: User { 
        User(id: "1", profileImage: "", profileImageDesaturated: "", userName: "NaN", profileDescription: "")
    }
}
extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case profileImage
        case profileImageDesaturated
        case userName
        case profileDescription
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        profileImage = try values.decode(String.self, forKey: .profileImage)
        profileImageDesaturated = try values.decode(String.self, forKey: .profileImageDesaturated)
        userName = try? values.decode(String.self, forKey: .userName)
        profileDescription = try? values.decode(String.self, forKey: .profileDescription)
    }

    func encode(with encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(profileImage, forKey: .profileImage)
        try container.encode(profileImageDesaturated, forKey: .profileImageDesaturated)
        try container.encode(userName, forKey: .userName)
        try container.encode(profileDescription, forKey: .profileDescription)
    }


}


