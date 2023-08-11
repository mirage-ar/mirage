// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension MirageAPI {
  struct CollectMiraInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      miraId: ID
    ) {
      __data = InputDict([
        "miraId": miraId
      ])
    }

    public var miraId: ID {
      get { __data["miraId"] }
      set { __data["miraId"] = newValue }
    }
  }

}