// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class VerifyUserMutation: GraphQLMutation {
    static let operationName: String = "VerifyUser"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation VerifyUser($verifyUserInput: VerificationInput!) { verifyUser(input: $verifyUserInput) { __typename user { __typename id phone profileImage profileDescription username } accessToken } }"#
      ))

    public var verifyUserInput: VerificationInput

    public init(verifyUserInput: VerificationInput) {
      self.verifyUserInput = verifyUserInput
    }

    public var __variables: Variables? { ["verifyUserInput": verifyUserInput] }

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("verifyUser", VerifyUser?.self, arguments: ["input": .variable("verifyUserInput")]),
      ] }

      var verifyUser: VerifyUser? { __data["verifyUser"] }

      /// VerifyUser
      ///
      /// Parent Type: `VerificationResult`
      struct VerifyUser: MirageAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.VerificationResult }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("user", User.self),
          .field("accessToken", String.self),
        ] }

        var user: User { __data["user"] }
        var accessToken: String { __data["accessToken"] }

        /// VerifyUser.User
        ///
        /// Parent Type: `User`
        struct User: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
            .field("phone", String?.self),
            .field("profileImage", String?.self),
            .field("profileDescription", String?.self),
            .field("username", String.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
          var phone: String? { __data["phone"] }
          var profileImage: String? { __data["profileImage"] }
          var profileDescription: String? { __data["profileDescription"] }
          var username: String { __data["username"] }
        }
      }
    }
  }

}