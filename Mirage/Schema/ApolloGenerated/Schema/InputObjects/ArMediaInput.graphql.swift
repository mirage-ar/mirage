// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public extension MirageAPI {
  struct ArMediaInput: InputObject {
    public private(set) var __data: InputDict

    public init(_ data: InputDict) {
      __data = data
    }

    public init(
      contentType: GraphQLEnum<ContentType>,
      assetUrl: String,
      shape: GraphQLEnum<Shape>,
      position: PositionInput,
      modifier: GraphQLNullable<ModifierInput> = nil
    ) {
      __data = InputDict([
        "contentType": contentType,
        "assetUrl": assetUrl,
        "shape": shape,
        "position": position,
        "modifier": modifier
      ])
    }

    public var contentType: GraphQLEnum<ContentType> {
      get { __data["contentType"] }
      set { __data["contentType"] = newValue }
    }

    public var assetUrl: String {
      get { __data["assetUrl"] }
      set { __data["assetUrl"] = newValue }
    }

    public var shape: GraphQLEnum<Shape> {
      get { __data["shape"] }
      set { __data["shape"] = newValue }
    }

    public var position: PositionInput {
      get { __data["position"] }
      set { __data["position"] = newValue }
    }

    public var modifier: GraphQLNullable<ModifierInput> {
      get { __data["modifier"] }
      set { __data["modifier"] = newValue }
    }
  }

}