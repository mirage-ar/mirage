//
//  User.swift
//  Mirage
//
//  Created by Saad on 05/05/2023.
//

import Foundation

public struct User {
    let id: UUID
    let phone: String
    let userName: String?
    let profileImage: String
    let profileDescription: String?
    var collectedMiraCount = 0
    var mirasCount = 0
    
    init(id: UUID, profileImage: String, phone: String, userName: String?, profileDescription: String?) {
        self.id = id
        self.profileImage = profileImage
        self.phone = phone
        self.userName = userName
        self.profileDescription = profileDescription
    }

    init() {
        id = UUID()
        phone = ""
        userName = nil
        profileImage = ""
        profileDescription = nil
    }
}

// MARK: - API Translators

extension User {
    init(apiUser: MirageAPI.UserQuery.Data.User?) {
        id = UUID(uuidString: apiUser?.id ?? "") ?? UUID()
        phone = apiUser?.phone ?? ""
        userName = apiUser?.username ?? ""
        profileImage = apiUser?.profileImage ?? colorImages[Int.random(in: 0..<colorImages.count)]
        profileDescription = apiUser?.profileDescription
        collectedMiraCount = apiUser?.collected?.count ?? 0
        mirasCount = apiUser?.miras?.count ?? 0
    }
    
    init(verifyUser: MirageAPI.VerifyUserMutation.Data.VerifyUser.User) {
        id = UUID(uuidString: verifyUser.id) ?? UUID()
        phone = verifyUser.phone ?? ""
        profileImage = verifyUser.profileImage ?? ""
        userName = verifyUser.username
        profileDescription = verifyUser.profileDescription
    }

    func updated(apiUpdatedUser: MirageAPI.UpdateUserMutation.Data.UpdateUser?) -> User {
        return User(id: id, profileImage: profileImage, phone: apiUpdatedUser?.phone ?? "", userName: apiUpdatedUser?.username ?? "", profileDescription: apiUpdatedUser?.username ?? "")
    }

    init(creator: MirageAPI.GetMirasQuery.Data.GetMira.Creator?) {
        id = UUID(uuidString: creator?.id ?? "") ?? UUID()
        phone = creator?.phone ?? ""
        userName = creator?.username ?? ""
        profileImage = creator?.profileImage ?? ""
        profileDescription = creator?.profileDescription
    }

    init(collector: MirageAPI.GetMirasQuery.Data.GetMira.Collector?) {
        id = UUID(uuidString: collector?.id ?? "") ?? UUID()
        phone = collector?.phone ?? ""
        userName = collector?.username ?? ""
        profileImage = collector?.profileImage ?? ""
        profileDescription = collector?.profileDescription
    }
}

// MARK: - Hashable

extension User: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Dereive Properties

extension User {
    var isDescriptionEmpty: Bool {
        return !(profileDescription?.isEmpty == true || userName?.isEmpty == true)
    }

    static var dummy: User {
        User(id: UUID(uuidString: "1") ?? UUID(), profileImage: "", phone: "1231234", userName: "Dummy", profileDescription: "Dummy profile")
    }
}

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case phone
        case profileImage
        case userName
        case profileDescription
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        phone = try values.decode(String.self, forKey: .phone)
        profileImage = try values.decode(String.self, forKey: .profileImage)
        userName = try? values.decode(String.self, forKey: .userName)
        profileDescription = try? values.decode(String.self, forKey: .profileDescription)
    }

    func encode(with encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(phone, forKey: .phone)
        try container.encode(profileImage, forKey: .profileImage)
        try container.encode(userName, forKey: .userName)
        try container.encode(profileDescription, forKey: .profileDescription)
    }
}
