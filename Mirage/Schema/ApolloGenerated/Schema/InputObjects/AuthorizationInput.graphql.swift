// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct AuthorizationInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      phone: String
    ) {
      __data = InputDict([
        "phone": phone
      ])
    }

    var phone: String {
      get { __data["phone"] }
      set { __data["phone"] = newValue }
    }
  }

}