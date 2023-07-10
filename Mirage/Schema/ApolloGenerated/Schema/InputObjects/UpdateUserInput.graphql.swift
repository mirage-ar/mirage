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
      username: GraphQLNullable<String> = nil,
      profileImage: GraphQLNullable<String> = nil,
      profileDescription: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "username": username,
        "profileImage": profileImage,
        "profileDescription": profileDescription
      ])
    }

    public var username: GraphQLNullable<String> {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }

    public var profileImage: GraphQLNullable<String> {
      get { __data["profileImage"] }
      set { __data["profileImage"] = newValue }
    }

    public var profileDescription: GraphQLNullable<String> {
      get { __data["profileDescription"] }
      set { __data["profileDescription"] = newValue }
    }
  }

}