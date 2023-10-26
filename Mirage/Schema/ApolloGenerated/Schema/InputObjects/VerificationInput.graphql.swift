// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct VerificationInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      phone: String,
      code: String
    ) {
      __data = InputDict([
        "phone": phone,
        "code": code
      ])
    }

    var phone: String {
      get { __data["phone"] }
      set { __data["phone"] = newValue }
    }

    var code: String {
      get { __data["code"] }
      set { __data["code"] = newValue }
    }
  }

}