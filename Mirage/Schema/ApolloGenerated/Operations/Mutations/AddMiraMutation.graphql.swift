// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class AddMiraMutation: GraphQLMutation {
    static let operationName: String = "AddMira"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation AddMira($addMiraInput: AddMiraInput!) { addMira(input: $addMiraInput) { __typename id miraMedia { __typename assetUrl contentType shape modifier { __typename id type } position { __typename id transform } } creator { __typename id phone username profileImage profileDescription } location { __typename latitude longitude elevation heading } } }"#
      ))

    public var addMiraInput: AddMiraInput

    public init(addMiraInput: AddMiraInput) {
      self.addMiraInput = addMiraInput
    }

    public var __variables: Variables? { ["addMiraInput": addMiraInput] }

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      static var __selections: [ApolloAPI.Selection] { [
        .field("addMira", AddMira?.self, arguments: ["input": .variable("addMiraInput")]),
      ] }

      var addMira: AddMira? { __data["addMira"] }

      /// AddMira
      ///
      /// Parent Type: `Mira`
      struct AddMira: MirageAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", MirageAPI.ID.self),
          .field("miraMedia", [MiraMedium]?.self),
          .field("creator", Creator?.self),
          .field("location", Location?.self),
        ] }

        var id: MirageAPI.ID { __data["id"] }
        var miraMedia: [MiraMedium]? { __data["miraMedia"] }
        var creator: Creator? { __data["creator"] }
        var location: Location? { __data["location"] }

        /// AddMira.MiraMedium
        ///
        /// Parent Type: `ArMedia`
        struct MiraMedium: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.ArMedia }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("assetUrl", String.self),
            .field("contentType", GraphQLEnum<MirageAPI.ContentType>.self),
            .field("shape", GraphQLEnum<MirageAPI.Shape>.self),
            .field("modifier", Modifier?.self),
            .field("position", Position?.self),
          ] }

          var assetUrl: String { __data["assetUrl"] }
          var contentType: GraphQLEnum<MirageAPI.ContentType> { __data["contentType"] }
          var shape: GraphQLEnum<MirageAPI.Shape> { __data["shape"] }
          var modifier: Modifier? { __data["modifier"] }
          var position: Position? { __data["position"] }

          /// AddMira.MiraMedium.Modifier
          ///
          /// Parent Type: `Modifier`
          struct Modifier: MirageAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Modifier }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", MirageAPI.ID.self),
              .field("type", GraphQLEnum<MirageAPI.ModifierType>.self),
            ] }

            var id: MirageAPI.ID { __data["id"] }
            var type: GraphQLEnum<MirageAPI.ModifierType> { __data["type"] }
          }

          /// AddMira.MiraMedium.Position
          ///
          /// Parent Type: `Position`
          struct Position: MirageAPI.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Position }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", MirageAPI.ID.self),
              .field("transform", [[Double]].self),
            ] }

            var id: MirageAPI.ID { __data["id"] }
            var transform: [[Double]] { __data["transform"] }
          }
        }

        /// AddMira.Creator
        ///
        /// Parent Type: `User`
        struct Creator: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
            .field("phone", String?.self),
            .field("username", String.self),
            .field("profileImage", String?.self),
            .field("profileDescription", String?.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
          var phone: String? { __data["phone"] }
          var username: String { __data["username"] }
          var profileImage: String? { __data["profileImage"] }
          var profileDescription: String? { __data["profileDescription"] }
        }

        /// AddMira.Location
        ///
        /// Parent Type: `Location`
        struct Location: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Location }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("latitude", Double.self),
            .field("longitude", Double.self),
            .field("elevation", Double?.self),
            .field("heading", Double?.self),
          ] }

          var latitude: Double { __data["latitude"] }
          var longitude: Double { __data["longitude"] }
          var elevation: Double? { __data["elevation"] }
          var heading: Double? { __data["heading"] }
        }
      }
    }
  }

}