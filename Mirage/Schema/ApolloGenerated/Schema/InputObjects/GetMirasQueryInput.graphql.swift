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
      userId: ID,
      accessToken: String,
      location: LocationInput,
      zoomLevel: GraphQLNullable<Int> = nil
    ) {
      __data = InputDict([
        "userId": userId,
        "accessToken": accessToken,
        "location": location,
        "zoomLevel": zoomLevel
      ])
    }

    public var userId: ID {
      get { __data["userId"] }
      set { __data["userId"] = newValue }
    }

    public var accessToken: String {
      get { __data["accessToken"] }
      set { __data["accessToken"] = newValue }
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