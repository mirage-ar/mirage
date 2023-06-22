// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct GetMirasQueryInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      location: LocationInput,
      zoomLevel: GraphQLNullable<Int> = nil,
      radius: Double
    ) {
      __data = InputDict([
        "location": location,
        "zoomLevel": zoomLevel,
        "radius": radius
      ])
    }

    var location: LocationInput {
      get { __data["location"] }
      set { __data["location"] = newValue }
    }

    var zoomLevel: GraphQLNullable<Int> {
      get { __data["zoomLevel"] }
      set { __data["zoomLevel"] = newValue }
    }

    var radius: Double {
      get { __data["radius"] }
      set { __data["radius"] = newValue }
    }
  }

}