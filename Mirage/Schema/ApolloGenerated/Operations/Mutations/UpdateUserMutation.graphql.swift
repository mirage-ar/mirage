// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class UpdateUserMutation: GraphQLMutation {
    public static let operationName: String = "UpdateUser"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation UpdateUser($updateUserInput: UpdateUserInput!) {
          updateUser(input: $updateUserInput) {
            __typename
            id
            phone
            username
            profileImage
            profileDescription
          }
        }
        """#
      ))

    public var updateUserInput: UpdateUserInput

    public init(updateUserInput: UpdateUserInput) {
      self.updateUserInput = updateUserInput
    }

    public var __variables: Variables? { ["updateUserInput": updateUserInput] }

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateUser", UpdateUser?.self, arguments: ["input": .variable("updateUserInput")]),
      ] }

      public var updateUser: UpdateUser? { __data["updateUser"] }

      /// UpdateUser
      ///
      /// Parent Type: `User`
      public struct UpdateUser: MirageAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", MirageAPI.ID.self),
          .field("phone", String?.self),
          .field("username", String.self),
          .field("profileImage", String?.self),
          .field("profileDescription", String?.self),
        ] }

        public var id: MirageAPI.ID { __data["id"] }
        public var phone: String? { __data["phone"] }
        public var username: String { __data["username"] }
        public var profileImage: String? { __data["profileImage"] }
        public var profileDescription: String? { __data["profileDescription"] }
      }
    }
  }

}