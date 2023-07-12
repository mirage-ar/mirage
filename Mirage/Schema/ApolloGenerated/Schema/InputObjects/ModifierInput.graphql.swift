// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension MirageAPI {
  struct ModifierInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      type: GraphQLEnum<ModifierType>,
      amount: Double
    ) {
      __data = InputDict([
        "type": type,
        "amount": amount
      ])
    }

    public var type: GraphQLEnum<ModifierType> {
      get { __data["type"] }
      set { __data["type"] = newValue }
    }

    public var amount: Double {
      get { __data["amount"] }
      set { __data["amount"] = newValue }
    }
  }

}