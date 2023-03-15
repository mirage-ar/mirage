// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension MirageAPI {
  struct VerificationInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      phone: String,
      code: String
    ) {
      __data = InputDict([
        "phone": phone,
        "code": code
      ])
    }

    public var phone: String {
      get { __data["phone"] }
      set { __data["phone"] = newValue }
    }

    public var code: String {
      get { __data["code"] }
      set { __data["code"] = newValue }
    }
  }

}