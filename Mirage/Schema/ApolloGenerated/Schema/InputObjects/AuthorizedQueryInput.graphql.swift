// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension MirageAPI {
  struct AuthorizedQueryInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      userId: ID,
      accessToken: String
    ) {
      __data = InputDict([
        "userId": userId,
        "accessToken": accessToken
      ])
    }

    public var userId: ID {
      get { __data["userId"] }
      set { __data["userId"] = newValue }
    }

    public var accessToken: String {
      get { __data["accessToken"] }
      set { __data["accessToken"] = newValue }
    }
  }

}