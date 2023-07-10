// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension MirageAPI {
  struct LocationInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
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

    public var latitude: Double {
      get { __data["latitude"] }
      set { __data["latitude"] = newValue }
    }

    public var longitude: Double {
      get { __data["longitude"] }
      set { __data["longitude"] = newValue }
    }

    public var elevation: GraphQLNullable<Double> {
      get { __data["elevation"] }
      set { __data["elevation"] = newValue }
    }
  }

}