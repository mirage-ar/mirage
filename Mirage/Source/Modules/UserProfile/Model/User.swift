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
    var profileImage: String
    let profileDescription: String?
    var collectedMiraCount = 0
    var mirasCount = 0
    var friends: [User]?
    var pendingRequests: [User]?
    var sentRequests: [User]?
    
    var friendshipStatus: FriendshipStatus = .none
    var createdMiraIds: [UUID]?
    var collectedMiraIds: [UUID]?
    
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
        profileImage = apiUser?.profileImage ?? "https://mirage-pfp.s3.amazonaws.com/green.png"
        profileDescription = apiUser?.profileDescription
        collectedMiraCount = apiUser?.collected?.count ?? 0
        mirasCount = apiUser?.miras?.count ?? 0
        if let status =  apiUser?.friendshipStatus {
            friendshipStatus = FriendshipStatus(status: status)
        }
        if let miras = apiUser?.miras, let collected = apiUser?.collected {
            createdMiraIds = miras.map { mira in
                return UUID(uuidString: mira!.id) ?? UUID()
            }
            collectedMiraIds = collected.map { mira in
                return UUID(uuidString: mira!.id) ?? UUID()
            }
        }
        if let userFriends = apiUser?.friends {
            friends = userFriends.map{ friend in
                User(apiUser: friend)
            }
        }
        if let sentRequests = apiUser?.sentRequests {
            self.sentRequests = sentRequests.map{ friend in
                User(apiUser: friend)
            }
        }
        if let pendingRequests = apiUser?.pendingRequests {
            self.pendingRequests = pendingRequests.map{ friend in
                User(apiUser: friend)
            }
        }
    }
    
    init(apiUser: MirageAPI.UserQuery.Data.User.Friend?) {
        id = UUID(uuidString: apiUser?.id ?? "") ?? UUID()
        phone = apiUser?.phone ?? ""
        userName = apiUser?.username ?? ""
        profileImage = apiUser?.profileImage ?? ""
        profileDescription = apiUser?.profileDescription
        if let status =  apiUser?.friendshipStatus {
            friendshipStatus = FriendshipStatus(status: status)
        }
    }
    init(apiUser: MirageAPI.UserQuery.Data.User.SentRequest?) {
        id = UUID(uuidString: apiUser?.id ?? "") ?? UUID()
        phone = apiUser?.phone ?? ""
        userName = apiUser?.username ?? ""
        profileImage = apiUser?.profileImage ?? ""
        profileDescription = apiUser?.profileDescription
        if let status =  apiUser?.friendshipStatus {
            friendshipStatus = FriendshipStatus(status: status)
        }
    }
    init(apiUser: MirageAPI.UserQuery.Data.User.PendingRequest?) {
        id = UUID(uuidString: apiUser?.id ?? "") ?? UUID()
        phone = apiUser?.phone ?? ""
        userName = apiUser?.username ?? ""
        profileImage = apiUser?.profileImage ?? ""
        profileDescription = apiUser?.profileDescription
        if let status =  apiUser?.friendshipStatus {
            friendshipStatus = FriendshipStatus(status: status)
        }
    }
    
    init(verifyUser: MirageAPI.VerifyUserMutation.Data.VerifyUser.User) {
        id = UUID(uuidString: verifyUser.id) ?? UUID()
        phone = verifyUser.phone ?? ""
        profileImage = verifyUser.profileImage ?? ""
        userName = verifyUser.username
        profileDescription = verifyUser.profileDescription
    }

    init(apiUser: MirageAPI.UpdateUserMutation.Data.UpdateUser?) {
        id = UUID(uuidString: apiUser?.id ?? "") ?? UUID()
        phone = apiUser?.phone ?? ""
        userName = apiUser?.username ?? ""
        profileImage = apiUser?.profileImage ?? colorImages[Int.random(in: 0..<colorImages.count)]
        profileDescription = apiUser?.profileDescription
        collectedMiraCount = apiUser?.collected?.count ?? 0
        mirasCount = apiUser?.miras?.count ?? 0
        if let miras = apiUser?.miras, let collected = apiUser?.collected {
            createdMiraIds = miras.map { mira in
                return UUID(uuidString: mira!.id) ?? UUID()
            }
            collectedMiraIds = collected.map { mira in
                return UUID(uuidString: mira!.id) ?? UUID()
            }
        }
    }

    init(creator: MirageAPI.GetMirasQuery.Data.GetMira.Creator?) {
        id = UUID(uuidString: creator?.id ?? "") ?? UUID()
        phone = creator?.phone ?? ""
        userName = creator?.username ?? ""
        profileImage = creator?.profileImage ?? ""
        profileDescription = creator?.profileDescription
        if let status =  creator?.friendshipStatus {
            friendshipStatus = FriendshipStatus(status: status)
        }
    }

    init(collector: MirageAPI.GetMirasQuery.Data.GetMira.Collector?) {
        id = UUID(uuidString: collector?.id ?? "") ?? UUID()
        phone = collector?.phone ?? ""
        userName = collector?.username ?? ""
        profileImage = collector?.profileImage ?? ""
        profileDescription = collector?.profileDescription
        if let status =  collector?.friendshipStatus {
            friendshipStatus = FriendshipStatus(status: status)
        }
    }
    
    init(collector: MirageAPI.OnMiraAddSubscription.Data.MiraAdded.Collector?) {
        id = UUID(uuidString: collector?.id ?? "") ?? UUID()
        phone = collector?.phone ?? ""
        userName = collector?.username ?? ""
        profileImage = collector?.profileImage ?? ""
        profileDescription = collector?.profileDescription
        if let status =  collector?.friendshipStatus {
            friendshipStatus = FriendshipStatus(status: status)
        }
    }
    
    init(creator: MirageAPI.OnMiraAddSubscription.Data.MiraAdded.Creator?) {
        id = UUID(uuidString: creator?.id ?? "") ?? UUID()
        phone = creator?.phone ?? "1234"
        userName = creator?.username ?? ""
        profileImage = creator?.profileImage ?? ""
        profileDescription = creator?.profileDescription ?? "xyz"
        if let status =  creator?.friendshipStatus {
            friendshipStatus = FriendshipStatus(status: status)
        }
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
//        return !(profileDescription?.isEmpty == true || userName?.isEmpty == true) for some reason this was incorrect logic
        return (profileDescription?.isEmpty == true || userName?.isEmpty == true)
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
        case collectedMiraCount
        case mirasCount
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        phone = try values.decode(String.self, forKey: .phone)
        profileImage = try values.decode(String.self, forKey: .profileImage)
        userName = try? values.decode(String.self, forKey: .userName)
        profileDescription = try? values.decode(String.self, forKey: .profileDescription)
        collectedMiraCount = (try? values.decode(Int.self, forKey: .collectedMiraCount)) ?? 0
        mirasCount = (try? values.decode(Int.self, forKey: .mirasCount)) ?? 0

    }

    func encode(with encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(phone, forKey: .phone)
        try container.encode(profileImage, forKey: .profileImage)
        try container.encode(userName, forKey: .userName)
        try container.encode(profileDescription, forKey: .profileDescription)
        try container.encode(collectedMiraCount, forKey: .collectedMiraCount)
        try container.encode(mirasCount, forKey: .mirasCount)

    }
}

enum FriendshipStatus: Int {
    case none = 0, pending, requested, accepted, rejected
    init(status: GraphQLEnum<MirageAPI.FriendshipStatus>) {
        
        switch status {
        case .accepted:
            self = .accepted
        case .pending:
            self = .pending

        case .requested:
            self = .requested

        case .rejected:
            self = .rejected

        case .none:
            self = .none

        case .case(_):
            self = .none

        case .unknown(_):
            self = .none
        }
        
    }
    init(stringValue: String) {
        let status = MirageAPI.FriendshipStatus(rawValue: stringValue) ?? .none
        switch status {
        case .accepted:
            self = .accepted
        case .pending:
            self = .pending

        case .requested:
            self = .requested

        case .rejected:
            self = .rejected

        case .none:
            self = .none

        }
    }
    var stringValue: String{
        switch self {
        case .none:
            return MirageAPI.FriendshipStatus.none.rawValue
        case .pending:
            return MirageAPI.FriendshipStatus.pending.rawValue
        case .requested:
            return MirageAPI.FriendshipStatus.requested.rawValue

        case .accepted:
            return MirageAPI.FriendshipStatus.accepted.rawValue

        case .rejected:
            return MirageAPI.FriendshipStatus.rejected.rawValue

        }
    }
}
