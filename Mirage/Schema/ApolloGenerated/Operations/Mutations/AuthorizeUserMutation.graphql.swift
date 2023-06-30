// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class AuthorizeUserMutation: GraphQLMutation {
    static let operationName: String = "AuthorizeUser"
    static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation AuthorizeUser($authorizeUserInput: AuthorizationInput!) {
          authorizeUser(input: $authorizeUserInput) {
            __typename
            user {
              __typename
              id
            }
            accountStage
          }
        }
        """#
      ))

    public var authorizeUserInput: AuthorizationInput

    public init(authorizeUserInput: AuthorizationInput) {
      self.authorizeUserInput = authorizeUserInput
    }

    public var __variables: Variables? { ["authorizeUserInput": authorizeUserInput] }

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(data: DataDict) { __data = data }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("authorizeUser", AuthorizeUser?.self, arguments: ["input": .variable("authorizeUserInput")]),
      ] }

      var authorizeUser: AuthorizeUser? { __data["authorizeUser"] }

      /// AuthorizeUser
      ///
      /// Parent Type: `AuthorizationResult`
      struct AuthorizeUser: MirageAPI.SelectionSet {
        let __data: DataDict
        init(data: DataDict) { __data = data }

        static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.AuthorizationResult }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("user", User.self),
          .field("accountStage", GraphQLEnum<MirageAPI.AccountStage>.self),
        ] }

        var user: User { __data["user"] }
        var accountStage: GraphQLEnum<MirageAPI.AccountStage> { __data["accountStage"] }

        /// AuthorizeUser.User
        ///
        /// Parent Type: `User`
        struct User: MirageAPI.SelectionSet {
          let __data: DataDict
          init(data: DataDict) { __data = data }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
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
