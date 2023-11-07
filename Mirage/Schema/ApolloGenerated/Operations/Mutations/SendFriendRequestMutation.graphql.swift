// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class SendFriendRequestMutation: GraphQLMutation {
    static let operationName: String = "SendFriendRequestMutation"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation SendFriendRequestMutation($recipientId: ID!) { sendFriendRequest(recipientId: $recipientId) { __typename id status } }"#
      ))

    public var recipientId: ID

    public init(recipientId: ID) {
      self.recipientId = recipientId
    }

    public var __variables: Variables? { ["recipientId": recipientId] }

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("sendFriendRequest", SendFriendRequest.self, arguments: ["recipientId": .variable("recipientId")]),
      ] }

      var sendFriendRequest: SendFriendRequest { __data["sendFriendRequest"] }

      /// SendFriendRequest
      ///
      /// Parent Type: `FriendRequest`
      struct SendFriendRequest: MirageAPI.SelectionSet {
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