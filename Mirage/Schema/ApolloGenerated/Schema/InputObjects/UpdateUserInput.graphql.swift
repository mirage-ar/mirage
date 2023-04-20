// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension MirageAPI {
  struct UpdateUserInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      userId: ID,
      accessToken: String,
      username: GraphQLNullable<String> = nil,
      pfp: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "userId": userId,
        "accessToken": accessToken,
        "username": username,
        "pfp": pfp
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

    public var username: GraphQLNullable<String> {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }

    public var pfp: GraphQLNullable<String> {
      get { __data["pfp"] }
      set { __data["pfp"] = newValue }
    }
  }

}