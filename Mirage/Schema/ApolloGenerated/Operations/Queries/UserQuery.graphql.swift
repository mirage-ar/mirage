// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class UserQuery: GraphQLQuery {
    public static let operationName: String = "User"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query User($authorizedQueryInput: AuthorizedQueryInput!) {
          user(input: $authorizedQueryInput) {
            __typename
            id
            phone
            username
            pfp
          }
        }
        """#
      ))

    public var authorizedQueryInput: AuthorizedQueryInput

    public init(authorizedQueryInput: AuthorizedQueryInput) {
      self.authorizedQueryInput = authorizedQueryInput
    }

    public var __variables: Variables? { ["authorizedQueryInput": authorizedQueryInput] }

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("user", User?.self, arguments: ["input": .variable("authorizedQueryInput")]),
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
          .field("pfp", String?.self),
        ] }

        public var id: MirageAPI.ID { __data["id"] }
        public var phone: String? { __data["phone"] }
        public var username: String { __data["username"] }
        public var pfp: String? { __data["pfp"] }
      }
    }
  }

}