// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class UserQuery: GraphQLQuery {
    static let operationName: String = "User"
    static let document: ApolloAPI.DocumentType = .notPersisted(
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

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(data: DataDict) { __data = data }

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
        init(data: DataDict) { __data = data }

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
          .field("collected", [Collected?]?.self),
          .field("miras", [Mira?]?.self),
        ] }

        var id: MirageAPI.ID { __data["id"] }
        var phone: String? { __data["phone"] }
        var username: String { __data["username"] }
        var profileImage: String? { __data["profileImage"] }
        var profileDescription: String? { __data["profileDescription"] }
        var accessToken: String? { __data["accessToken"] }
        var verificationSid: String? { __data["verificationSid"] }
        var collected: [Collected?]? { __data["collected"] }
        var miras: [Mira?]? { __data["miras"] }

        /// User.Collected
        ///
        /// Parent Type: `Mira`
        struct Collected: MirageAPI.SelectionSet {
          let __data: DataDict
          init(data: DataDict) { __data = data }

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
          init(data: DataDict) { __data = data }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
        }
      }
    }
  }

}
