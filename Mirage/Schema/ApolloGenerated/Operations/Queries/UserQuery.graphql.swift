// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class UserQuery: GraphQLQuery {
    static let operationName: String = "User"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query User($userId: ID) { user(userId: $userId) { __typename id phone username profileImage profileDescription accessToken verificationSid friendshipStatus collected { __typename id } miras { __typename id } friends { __typename id phone username profileImage profileDescription friendshipStatus } sentRequests { __typename id phone username profileImage profileDescription friendshipStatus } pendingRequests { __typename id phone username profileImage profileDescription friendshipStatus } } }"#
      ))

    public var userId: GraphQLNullable<ID>

    public init(userId: GraphQLNullable<ID>) {
      self.userId = userId
    }

    public var __variables: Variables? { ["userId": userId] }

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("user", User?.self, arguments: ["userId": .variable("userId")]),
      ] }

      var user: User? { __data["user"] }

      /// User
      ///
      /// Parent Type: `User`
      struct User: MirageAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", MirageAPI.ID.self),
          .field("phone", String?.self),
          .field("username", String.self),
          .field("profileImage", String?.self),
          .field("profileDescription", String?.self),
          .field("accessToken", String?.self),
          .field("verificationSid", String?.self),
          .field("friendshipStatus", GraphQLEnum<MirageAPI.FriendshipStatus>?.self),
          .field("collected", [Collected?]?.self),
          .field("miras", [Mira?]?.self),
          .field("friends", [Friend?]?.self),
          .field("sentRequests", [SentRequest?]?.self),
          .field("pendingRequests", [PendingRequest?]?.self),
        ] }

        var id: MirageAPI.ID { __data["id"] }
        var phone: String? { __data["phone"] }
        var username: String { __data["username"] }
        var profileImage: String? { __data["profileImage"] }
        var profileDescription: String? { __data["profileDescription"] }
        var accessToken: String? { __data["accessToken"] }
        var verificationSid: String? { __data["verificationSid"] }
        var friendshipStatus: GraphQLEnum<MirageAPI.FriendshipStatus>? { __data["friendshipStatus"] }
        var collected: [Collected?]? { __data["collected"] }
        var miras: [Mira?]? { __data["miras"] }
        var friends: [Friend?]? { __data["friends"] }
        var sentRequests: [SentRequest?]? { __data["sentRequests"] }
        var pendingRequests: [PendingRequest?]? { __data["pendingRequests"] }

        /// User.Collected
        ///
        /// Parent Type: `Mira`
        struct Collected: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
        }

        /// User.Mira
        ///
        /// Parent Type: `Mira`
        struct Mira: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
        }

        /// User.Friend
        ///
        /// Parent Type: `User`
        struct Friend: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
            .field("phone", String?.self),
            .field("username", String.self),
            .field("profileImage", String?.self),
            .field("profileDescription", String?.self),
            .field("friendshipStatus", GraphQLEnum<MirageAPI.FriendshipStatus>?.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
          var phone: String? { __data["phone"] }
          var username: String { __data["username"] }
          var profileImage: String? { __data["profileImage"] }
          var profileDescription: String? { __data["profileDescription"] }
          var friendshipStatus: GraphQLEnum<MirageAPI.FriendshipStatus>? { __data["friendshipStatus"] }
        }

        /// User.SentRequest
        ///
        /// Parent Type: `User`
        struct SentRequest: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
            .field("phone", String?.self),
            .field("username", String.self),
            .field("profileImage", String?.self),
            .field("profileDescription", String?.self),
            .field("friendshipStatus", GraphQLEnum<MirageAPI.FriendshipStatus>?.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
          var phone: String? { __data["phone"] }
          var username: String { __data["username"] }
          var profileImage: String? { __data["profileImage"] }
          var profileDescription: String? { __data["profileDescription"] }
          var friendshipStatus: GraphQLEnum<MirageAPI.FriendshipStatus>? { __data["friendshipStatus"] }
        }

        /// User.PendingRequest
        ///
        /// Parent Type: `User`
        struct PendingRequest: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
            .field("phone", String?.self),
            .field("username", String.self),
            .field("profileImage", String?.self),
            .field("profileDescription", String?.self),
            .field("friendshipStatus", GraphQLEnum<MirageAPI.FriendshipStatus>?.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
          var phone: String? { __data["phone"] }
          var username: String { __data["username"] }
          var profileImage: String? { __data["profileImage"] }
          var profileDescription: String? { __data["profileDescription"] }
          var friendshipStatus: GraphQLEnum<MirageAPI.FriendshipStatus>? { __data["friendshipStatus"] }
        }
      }
    }
  }

}