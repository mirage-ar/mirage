// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class UserQuery: GraphQLQuery {
    public static let operationName: String = "User"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query User($userId: ID) {
          user(userId: $userId) {
            __typename
            id
            phone
            username
            profileImage
            profileDescription
            accessToken
            verificationSid
            collected {
              __typename
              id
            }
            miras {
              __typename
              id
            }
          }
        }
        """#
      ))

    public var userId: GraphQLNullable<ID>

    public init(userId: GraphQLNullable<ID>) {
      self.userId = userId
    }

    public var __variables: Variables? { ["userId": userId] }

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("user", User?.self, arguments: ["userId": .variable("userId")]),
      ] }

      public var user: User? { __data["user"] }

      /// User
      ///
      /// Parent Type: `User`
      public struct User: MirageAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", MirageAPI.ID.self),
          .field("phone", String?.self),
          .field("username", String.self),
          .field("profileImage", String?.self),
          .field("profileDescription", String?.self),
          .field("accessToken", String?.self),
          .field("verificationSid", String?.self),
          .field("collected", [Collected?]?.self),
          .field("miras", [Mira?]?.self),
        ] }

        public var id: MirageAPI.ID { __data["id"] }
        public var phone: String? { __data["phone"] }
        public var username: String { __data["username"] }
        public var profileImage: String? { __data["profileImage"] }
        public var profileDescription: String? { __data["profileDescription"] }
        public var accessToken: String? { __data["accessToken"] }
        public var verificationSid: String? { __data["verificationSid"] }
        public var collected: [Collected?]? { __data["collected"] }
        public var miras: [Mira?]? { __data["miras"] }

        /// User.Collected
        ///
        /// Parent Type: `Mira`
        public struct Collected: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
          ] }

          public var id: MirageAPI.ID { __data["id"] }
        }

        /// User.Mira
        ///
        /// Parent Type: `Mira`
        public struct Mira: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
          ] }

          public var id: MirageAPI.ID { __data["id"] }
        }
      }
    }
  }

}