// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

extension MirageAPI {
  struct ArMediaInput: InputObject {
    private(set) var __data: InputDict

    init(_ data: InputDict) {
      __data = data
    }

    init(
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

    var contentType: GraphQLEnum<ContentType> {
      get { __data["contentType"] }
      set { __data["contentType"] = newValue }
    }

    var assetUrl: String {
      get { __data["assetUrl"] }
      set { __data["assetUrl"] = newValue }
    }

    var shape: GraphQLEnum<Shape> {
      get { __data["shape"] }
      set { __data["shape"] = newValue }
    }

    var position: PositionInput {
      get { __data["position"] }
      set { __data["position"] = newValue }
    }

    var modifier: GraphQLNullable<ModifierInput> {
      get { __data["modifier"] }
      set { __data["modifier"] = newValue }
    }
  }

}