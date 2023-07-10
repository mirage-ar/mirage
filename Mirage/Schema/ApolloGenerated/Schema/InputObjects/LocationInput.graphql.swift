// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct LocationInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
      latitude: Double,
      longitude: Double,
      elevation: GraphQLNullable<Double> = nil
    ) {
      __data = InputDict([
        "latitude": latitude,
        "longitude": longitude,
        "elevation": elevation
      ])
    }

    var latitude: Double {
      get { __data["latitude"] }
      set { __data["latitude"] = newValue }
    }

    var longitude: Double {
      get { __data["longitude"] }
      set { __data["longitude"] = newValue }
    }

    var elevation: GraphQLNullable<Double> {
      get { __data["elevation"] }
      set { __data["elevation"] = newValue }
    }
  }

}