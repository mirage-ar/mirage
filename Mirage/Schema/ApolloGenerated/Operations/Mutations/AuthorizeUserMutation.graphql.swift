// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class AuthorizeUserMutation: GraphQLMutation {
    public static let operationName: String = "AuthorizeUser"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
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

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("authorizeUser", AuthorizeUser?.self, arguments: ["input": .variable("authorizeUserInput")]),
      ] }

      public var authorizeUser: AuthorizeUser? { __data["authorizeUser"] }

      /// AuthorizeUser
      ///
      /// Parent Type: `AuthorizationResult`
      public struct AuthorizeUser: MirageAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.AuthorizationResult }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("user", User.self),
          .field("accountStage", GraphQLEnum<MirageAPI.AccountStage>.self),
        ] }

        public var user: User { __data["user"] }
        public var accountStage: GraphQLEnum<MirageAPI.AccountStage> { __data["accountStage"] }

        /// AuthorizeUser.User
        ///
        /// Parent Type: `User`
        public struct User: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
          ] }

          public var id: MirageAPI.ID { __data["id"] }
        }
      }
    }
  }

}