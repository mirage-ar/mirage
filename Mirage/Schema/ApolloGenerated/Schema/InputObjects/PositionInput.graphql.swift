// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension MirageAPI {
  struct PositionInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      transform: [[Double]]
    ) {
      __data = InputDict([
        "transform": transform
      ])
    }

    public var transform: [[Double]] {
      get { __data["transform"] }
      set { __data["transform"] = newValue }
    }
  }

}