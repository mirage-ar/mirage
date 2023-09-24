// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct CollectMiraInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      miraId: ID
    ) {
      __data = InputDict([
        "miraId": miraId
      ])
    }

    var miraId: ID {
      get { __data["miraId"] }
      set { __data["miraId"] = newValue }
    }
  }

}