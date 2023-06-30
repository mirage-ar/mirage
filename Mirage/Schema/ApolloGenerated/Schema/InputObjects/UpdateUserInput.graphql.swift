// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct UpdateUserInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
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

    var username: GraphQLNullable<String> {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }

    var profileImage: GraphQLNullable<String> {
      get { __data["profileImage"] }
      set { __data["profileImage"] = newValue }
    }

    var profileDescription: GraphQLNullable<String> {
      get { __data["profileDescription"] }
      set { __data["profileDescription"] = newValue }
    }
  }

}