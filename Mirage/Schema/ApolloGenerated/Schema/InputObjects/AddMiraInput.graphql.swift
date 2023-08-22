// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension MirageAPI {
  struct AddMiraInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      location: LocationInput,
      arMedia: [ArMediaInput]
    ) {
      __data = InputDict([
        "location": location,
        "arMedia": arMedia
      ])
    }

    public var location: LocationInput {
      get { __data["location"] }
      set { __data["location"] = newValue }
    }

    public var arMedia: [ArMediaInput] {
      get { __data["arMedia"] }
      set { __data["arMedia"] = newValue }
    }
  }

}