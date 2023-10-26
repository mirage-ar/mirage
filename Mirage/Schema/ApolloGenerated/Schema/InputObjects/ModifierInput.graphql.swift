// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct ModifierInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      type: GraphQLEnum<ModifierType>,
      amount: GraphQLNullable<Double> = nil
    ) {
      __data = InputDict([
        "type": type,
        "amount": amount
      ])
    }

    var type: GraphQLEnum<ModifierType> {
      get { __data["type"] }
      set { __data["type"] = newValue }
    }

    var amount: GraphQLNullable<Double> {
      get { __data["amount"] }
      set { __data["amount"] = newValue }
    }
  }

}