// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct GetUsersQueryInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      username: GraphQLNullable<String> = nil,
      phone: GraphQLNullable<String> = nil
    ) {
      __data = InputDict([
        "username": username,
        "phone": phone
      ])
    }

    var username: GraphQLNullable<String> {
      get { __data["username"] }
      set { __data["username"] = newValue }
    }

    var phone: GraphQLNullable<String> {
      get { __data["phone"] }
      set { __data["phone"] = newValue }
    }
  }

}