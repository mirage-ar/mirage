// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class VerifyUserMutation: GraphQLMutation {
    public static let operationName: String = "VerifyUser"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation VerifyUser($verifyUserInput: VerificationInput!) {
          verifyUser(input: $verifyUserInput) {
            __typename
            user {
              __typename
              id
              phone
              profileImage
              profileDescription
              username
            }
            accessToken
          }
        }
        """#
      ))

    public var verifyUserInput: VerificationInput

    public init(verifyUserInput: VerificationInput) {
      self.verifyUserInput = verifyUserInput
    }

    public var __variables: Variables? { ["verifyUserInput": verifyUserInput] }

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("verifyUser", VerifyUser?.self, arguments: ["input": .variable("verifyUserInput")]),
      ] }

      public var verifyUser: VerifyUser? { __data["verifyUser"] }

      /// VerifyUser
      ///
      /// Parent Type: `VerificationResult`
      public struct VerifyUser: MirageAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.VerificationResult }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("user", User.self),
          .field("accessToken", String.self),
        ] }

        public var user: User { __data["user"] }
        public var accessToken: String { __data["accessToken"] }

        /// VerifyUser.User
        ///
        /// Parent Type: `User`
        public struct User: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
            .field("phone", String?.self),
            .field("profileImage", String?.self),
            .field("profileDescription", String?.self),
            .field("username", String.self),
          ] }

          public var id: MirageAPI.ID { __data["id"] }
          public var phone: String? { __data["phone"] }
          public var profileImage: String? { __data["profileImage"] }
          public var profileDescription: String? { __data["profileDescription"] }
          public var username: String { __data["username"] }
        }
      }
    }
  }

}