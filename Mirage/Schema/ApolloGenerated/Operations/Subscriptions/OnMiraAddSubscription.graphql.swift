// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class OnMiraAddSubscription: GraphQLSubscription {
    static let operationName: String = "OnMiraAdd"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"subscription OnMiraAdd { miraAdded { __typename id miraMedia { __typename contentType assetUrl shape position { __typename id transform } modifier { __typename id type } } creator { __typename id phone username profileImage profileDescription friendshipStatus } location { __typename latitude longitude elevation heading } viewed isFriend collectors { __typename id phone username profileImage profileDescription friendshipStatus } } }"#
      ))

    public init() {}

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Subscription }
      static var __selections: [ApolloAPI.Selection] { [
        .field("miraAdded", MiraAdded?.self),
      ] }

      var miraAdded: MiraAdded? { __data["miraAdded"] }

      /// MiraAdded
      ///
      /// Parent Type: `Mira`
      struct MiraAdded: MirageAPI.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", MirageAPI.ID.self),
          .field("miraMedia", [MiraMedium]?.self),
          .field("creator", Creator?.self),
          .field("location", Location?.self),
          .field("viewed", Bool?.self),
          .field("isFriend", Bool?.self),
          .field("collectors", [Collector]?.self),
        ] }

        var id: MirageAPI.ID { __data["id"] }
        var miraMedia: [MiraMedium]? { __data["miraMedia"] }
        var creator: Creator? { __data["creator"] }
        var location: Location? { __data["location"] }
        var viewed: Bool? { __data["viewed"] }
        var isFriend: Bool? { __data["isFriend"] }
        var collectors: [Collector]? { __data["collectors"] }

        /// MiraAdded.MiraMedium
        ///
        /// Parent Type: `ArMedia`
        struct MiraMedium: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.ArMedia }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("contentType", GraphQLEnum<MirageAPI.ContentType>.self),
            .field("assetUrl", String.self),
            .field("shape", GraphQLEnum<MirageAPI.Shape>.self),
            .field("position", Position?.self),
            .field("modifier", Modifier?.self),
          ] }

          var contentType: GraphQLEnum<MirageAPI.ContentType> { __data["contentType"] }
          var assetUrl: String { __data["assetUrl"] }
          var shape: GraphQLEnum<MirageAPI.Shape> { __data["shape"] }
          var position: Position? { __data["position"] }
          var modifier: Modifier? { __data["modifier"] }

          /// MiraAdded.MiraMedium.Position
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

          /// MiraAdded.MiraMedium.Modifier
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
        }

        /// MiraAdded.Creator
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
            .field("friendshipStatus", GraphQLEnum<MirageAPI.FriendshipStatus>?.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
          var phone: String? { __data["phone"] }
          var username: String { __data["username"] }
          var profileImage: String? { __data["profileImage"] }
          var profileDescription: String? { __data["profileDescription"] }
          var friendshipStatus: GraphQLEnum<MirageAPI.FriendshipStatus>? { __data["friendshipStatus"] }
        }

        /// MiraAdded.Location
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

        /// MiraAdded.Collector
        ///
        /// Parent Type: `User`
        struct Collector: MirageAPI.SelectionSet {
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
            .field("friendshipStatus", GraphQLEnum<MirageAPI.FriendshipStatus>?.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
          var phone: String? { __data["phone"] }
          var username: String { __data["username"] }
          var profileImage: String? { __data["profileImage"] }
          var profileDescription: String? { __data["profileDescription"] }
          var friendshipStatus: GraphQLEnum<MirageAPI.FriendshipStatus>? { __data["friendshipStatus"] }
        }
      }
    }
  }

}