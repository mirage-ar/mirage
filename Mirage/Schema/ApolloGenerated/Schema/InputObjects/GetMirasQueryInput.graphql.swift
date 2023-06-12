// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension MirageAPI {
  struct GetMirasQueryInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      location: LocationInput,
      zoomLevel: GraphQLNullable<Int> = nil
    ) {
      __data = InputDict([
        "location": location,
        "zoomLevel": zoomLevel
      ])
    }

    public var location: LocationInput {
      get { __data["location"] }
      set { __data["location"] = newValue }
    }

    public var zoomLevel: GraphQLNullable<Int> {
      get { __data["zoomLevel"] }
      set { __data["zoomLevel"] = newValue }
    }
  }

}