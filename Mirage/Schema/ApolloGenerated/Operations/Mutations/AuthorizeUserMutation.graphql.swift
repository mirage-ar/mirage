// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension Mirage/Schema/schema.json {
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
            verificationSid
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

    public struct Data: Mirage/Schema/schema.json.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { Mirage/Schema/schema.json.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("authorizeUser", AuthorizeUser?.self, arguments: ["input": .variable("authorizeUserInput")]),
      ] }

      public var authorizeUser: AuthorizeUser? { __data["authorizeUser"] }

      /// AuthorizeUser
      ///
      /// Parent Type: `AuthorizationResult`
      public struct AuthorizeUser: Mirage/Schema/schema.json.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { Mirage/Schema/schema.json.Objects.AuthorizationResult }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("user", User.self),
          .field("verificationSid", String.self),
          .field("accountStage", GraphQLEnum<Mirage/Schema/schema.json.AccountStage>.self),
        ] }

        public var user: User { __data["user"] }
        public var verificationSid: String { __data["verificationSid"] }
        public var accountStage: GraphQLEnum<Mirage/Schema/schema.json.AccountStage> { __data["accountStage"] }

        /// AuthorizeUser.User
        ///
        /// Parent Type: `User`
        public struct User: Mirage/Schema/schema.json.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { Mirage/Schema/schema.json.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", Mirage/Schema/schema.json.ID.self),
          ] }

          public var id: Mirage/Schema/schema.json.ID { __data["id"] }
        }
      }
    }
  }

}