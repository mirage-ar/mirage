// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct PositionInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      transform: [[Double]]
    ) {
      __data = InputDict([
        "transform": transform
      ])
    }

    var transform: [[Double]] {
      get { __data["transform"] }
      set { __data["transform"] = newValue }
    }
  }

}