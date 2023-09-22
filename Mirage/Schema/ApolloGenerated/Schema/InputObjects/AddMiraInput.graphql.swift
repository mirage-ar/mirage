// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct AddMiraInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      location: LocationInput,
      arMedia: [ArMediaInput]
    ) {
      __data = InputDict([
        "location": location,
        "arMedia": arMedia
      ])
    }

    var location: LocationInput {
      get { __data["location"] }
      set { __data["location"] = newValue }
    }

    var arMedia: [ArMediaInput] {
      get { __data["arMedia"] }
      set { __data["arMedia"] = newValue }
    }
  }

}