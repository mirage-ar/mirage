// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct UpdateFriendshipInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      recipientId: ID,
      status: GraphQLEnum<FriendshipStatus>
    ) {
      __data = InputDict([
        "recipientId": recipientId,
        "status": status
      ])
    }

    var recipientId: ID {
      get { __data["recipientId"] }
      set { __data["recipientId"] = newValue }
    }

    var status: GraphQLEnum<FriendshipStatus> {
      get { __data["status"] }
      set { __data["status"] = newValue }
    }
  }

}