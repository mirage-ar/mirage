// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class UserQuery: GraphQLQuery {
    public static let operationName: String = "User"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query User($userInput: UserInput!) {
          user(input: $userInput) {
            __typename
            id
            phone
            username
            pfp
          }
        }
        """#
      ))

    public var userInput: UserInput

    public init(userInput: UserInput) {
      self.userInput = userInput
    }

    public var __variables: Variables? { ["userInput": userInput] }

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("user", User?.self, arguments: ["input": .variable("userInput")]),
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
          .field("phone", String.self),
          .field("username", String?.self),
          .field("pfp", String?.self),
        ] }

        public var id: MirageAPI.ID { __data["id"] }
        public var phone: String { __data["phone"] }
        public var username: String? { __data["username"] }
        public var pfp: String? { __data["pfp"] }
      }
    }
  }

}