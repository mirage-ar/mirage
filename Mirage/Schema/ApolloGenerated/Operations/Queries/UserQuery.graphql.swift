// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class UserQuery: GraphQLQuery {
    public static let operationName: String = "User"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query User($userInput: AuthorizedQueryInput!) {
          user(input: $userInput) {
            __typename
            id
            username
            phone
            profileImage
            profileImageDesaturated
            miras {
              __typename
              id
            }
          }
        }
        """#
      ))

    public var userInput: AuthorizedQueryInput

    public init(userInput: AuthorizedQueryInput) {
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
          .field("username", String.self),
          .field("phone", String?.self),
          .field("profileImage", String?.self),
          .field("profileImageDesaturated", String?.self),
          .field("miras", [Mira?]?.self),
        ] }

        public var id: MirageAPI.ID { __data["id"] }
        public var username: String { __data["username"] }
        public var phone: String? { __data["phone"] }
        public var profileImage: String? { __data["profileImage"] }
        public var profileImageDesaturated: String? { __data["profileImageDesaturated"] }
        public var miras: [Mira?]? { __data["miras"] }

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