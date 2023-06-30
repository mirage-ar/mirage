// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class GetMirasQuery: GraphQLQuery {
    static let operationName: String = "GetMiras"
    static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query GetMiras($getMirasQueryInput: GetMirasQueryInput!) {
          getMiras(input: $getMirasQueryInput) {
            __typename
            id
            miraMedia {
              __typename
              contentType
              assetUrl
              shape
              position {
                __typename
                id
                transform
              }
              modifier {
                __typename
                id
                type
                amount
              }
            }
            creator {
              __typename
              id
              phone
              username
              profileImage
              profileDescription
            }
            location {
              __typename
              id
              latitude
              longitude
            }
            viewed
            isFriend
            collectors {
              __typename
              id
              phone
              username
              profileImage
              profileDescription
            }
          }
        }
        """#
      ))

    public var getMirasQueryInput: GetMirasQueryInput

    public init(getMirasQueryInput: GetMirasQueryInput) {
      self.getMirasQueryInput = getMirasQueryInput
    }

    public var __variables: Variables? { ["getMirasQueryInput": getMirasQueryInput] }

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(data: DataDict) { __data = data }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getMiras", [GetMira?]?.self, arguments: ["input": .variable("getMirasQueryInput")]),
      ] }

      var getMiras: [GetMira?]? { __data["getMiras"] }

      /// GetMira
      ///
      /// Parent Type: `Mira`
      struct GetMira: MirageAPI.SelectionSet {
        let __data: DataDict
        init(data: DataDict) { __data = data }

        static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", MirageAPI.ID.self),
          .field("miraMedia", [MiraMedium].self),
          .field("creator", Creator.self),
          .field("location", Location.self),
          .field("viewed", Bool.self),
          .field("isFriend", Bool.self),
          .field("collectors", [Collector?].self),
        ] }

        var id: MirageAPI.ID { __data["id"] }
        var miraMedia: [MiraMedium] { __data["miraMedia"] }
        var creator: Creator { __data["creator"] }
        var location: Location { __data["location"] }
        var viewed: Bool { __data["viewed"] }
        var isFriend: Bool { __data["isFriend"] }
        var collectors: [Collector?] { __data["collectors"] }

        /// GetMira.MiraMedium
        ///
        /// Parent Type: `ArMedia`
        struct MiraMedium: MirageAPI.SelectionSet {
          let __data: DataDict
          init(data: DataDict) { __data = data }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.ArMedia }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("contentType", GraphQLEnum<MirageAPI.ContentType>.self),
            .field("assetUrl", String.self),
            .field("shape", GraphQLEnum<MirageAPI.Shape>.self),
            .field("position", Position.self),
            .field("modifier", Modifier?.self),
          ] }

          var contentType: GraphQLEnum<MirageAPI.ContentType> { __data["contentType"] }
          var assetUrl: String { __data["assetUrl"] }
          var shape: GraphQLEnum<MirageAPI.Shape> { __data["shape"] }
          var position: Position { __data["position"] }
          var modifier: Modifier? { __data["modifier"] }

          /// GetMira.MiraMedium.Position
          ///
          /// Parent Type: `Position`
          struct Position: MirageAPI.SelectionSet {
            let __data: DataDict
            init(data: DataDict) { __data = data }

            static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Position }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", MirageAPI.ID.self),
              .field("transform", [[Double]].self),
            ] }

            var id: MirageAPI.ID { __data["id"] }
            var transform: [[Double]] { __data["transform"] }
          }

          /// GetMira.MiraMedium.Modifier
          ///
          /// Parent Type: `Modifier`
          struct Modifier: MirageAPI.SelectionSet {
            let __data: DataDict
            init(data: DataDict) { __data = data }

            static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Modifier }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", MirageAPI.ID.self),
              .field("type", GraphQLEnum<MirageAPI.ModifierType>.self),
              .field("amount", Double.self),
            ] }

            var id: MirageAPI.ID { __data["id"] }
            var type: GraphQLEnum<MirageAPI.ModifierType> { __data["type"] }
            var amount: Double { __data["amount"] }
          }
        }

        /// GetMira.Creator
        ///
        /// Parent Type: `User`
        struct Creator: MirageAPI.SelectionSet {
          let __data: DataDict
          init(data: DataDict) { __data = data }

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

        /// GetMira.Location
        ///
        /// Parent Type: `Location`
        struct Location: MirageAPI.SelectionSet {
          let __data: DataDict
          init(data: DataDict) { __data = data }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Location }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
            .field("latitude", Double.self),
            .field("longitude", Double.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
          var latitude: Double { __data["latitude"] }
          var longitude: Double { __data["longitude"] }
        }

        /// GetMira.Collector
        ///
        /// Parent Type: `User`
        struct Collector: MirageAPI.SelectionSet {
          let __data: DataDict
          init(data: DataDict) { __data = data }

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
      }
    }
  }

}
