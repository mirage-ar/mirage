// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class UpdateFriendRequestMutation: GraphQLMutation {
    static let operationName: String = "UpdateFriendRequestMutation"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateFriendRequestMutation($input: UpdateFriendshipInput!) { updateFriendRequest(input: $input) { __typename id status } }"#
      ))

    public var input: UpdateFriendshipInput

    public init(input: UpdateFriendshipInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("updateFriendRequest", UpdateFriendRequest.self, arguments: ["input": .variable("input")]),
      ] }

      var updateFriendRequest: UpdateFriendRequest { __data["updateFriendRequest"] }

      /// UpdateFriendRequest
      ///
      /// Parent Type: `FriendRequest`
      struct UpdateFriendRequest: MirageAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.FriendRequest }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", MirageAPI.ID.self),
          .field("status", GraphQLEnum<MirageAPI.FriendshipStatus>.self),
        ] }

        var id: MirageAPI.ID { __data["id"] }
        var status: GraphQLEnum<MirageAPI.FriendshipStatus> { __data["status"] }
      }
    }
  }

}