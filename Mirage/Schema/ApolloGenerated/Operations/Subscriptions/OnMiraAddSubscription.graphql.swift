// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class OnMiraAddSubscription: GraphQLSubscription {
    public static let operationName: String = "OnMiraAdd"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        subscription OnMiraAdd {
          miraAdded {
            __typename
            id
            miraMedia {
              __typename
              id
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
              elevation
              heading
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

    public init() {}

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Subscription }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("miraAdded", MiraAdded?.self),
      ] }

      public var miraAdded: MiraAdded? { __data["miraAdded"] }

      /// MiraAdded
      ///
      /// Parent Type: `Mira`
      public struct MiraAdded: MirageAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", MirageAPI.ID.self),
          .field("miraMedia", [MiraMedium]?.self),
          .field("creator", Creator?.self),
          .field("location", Location?.self),
          .field("viewed", Bool?.self),
          .field("isFriend", Bool?.self),
          .field("collectors", [Collector]?.self),
        ] }

        public var id: MirageAPI.ID { __data["id"] }
        public var miraMedia: [MiraMedium]? { __data["miraMedia"] }
        public var creator: Creator? { __data["creator"] }
        public var location: Location? { __data["location"] }
        public var viewed: Bool? { __data["viewed"] }
        public var isFriend: Bool? { __data["isFriend"] }
        public var collectors: [Collector]? { __data["collectors"] }

        /// MiraAdded.MiraMedium
        ///
        /// Parent Type: `ArMedia`
        public struct MiraMedium: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.ArMedia }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
            .field("contentType", GraphQLEnum<MirageAPI.ContentType>.self),
            .field("assetUrl", String.self),
            .field("shape", GraphQLEnum<MirageAPI.Shape>.self),
            .field("position", Position?.self),
            .field("modifier", Modifier?.self),
          ] }

          public var id: MirageAPI.ID { __data["id"] }
          public var contentType: GraphQLEnum<MirageAPI.ContentType> { __data["contentType"] }
          public var assetUrl: String { __data["assetUrl"] }
          public var shape: GraphQLEnum<MirageAPI.Shape> { __data["shape"] }
          public var position: Position? { __data["position"] }
          public var modifier: Modifier? { __data["modifier"] }

          /// MiraAdded.MiraMedium.Position
          ///
          /// Parent Type: `Position`
          public struct Position: MirageAPI.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Position }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("id", MirageAPI.ID.self),
              .field("transform", [[Double]].self),
            ] }

            public var id: MirageAPI.ID { __data["id"] }
            public var transform: [[Double]] { __data["transform"] }
          }

          /// MiraAdded.MiraMedium.Modifier
          ///
          /// Parent Type: `Modifier`
          public struct Modifier: MirageAPI.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Modifier }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("id", MirageAPI.ID.self),
              .field("type", GraphQLEnum<MirageAPI.ModifierType>.self),
              .field("amount", Double.self),
            ] }

            public var id: MirageAPI.ID { __data["id"] }
            public var type: GraphQLEnum<MirageAPI.ModifierType> { __data["type"] }
            public var amount: Double { __data["amount"] }
          }
        }

        /// MiraAdded.Creator
        ///
        /// Parent Type: `User`
        public struct Creator: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
            .field("phone", String?.self),
            .field("username", String.self),
            .field("profileImage", String?.self),
            .field("profileDescription", String?.self),
          ] }

          public var id: MirageAPI.ID { __data["id"] }
          public var phone: String? { __data["phone"] }
          public var username: String { __data["username"] }
          public var profileImage: String? { __data["profileImage"] }
          public var profileDescription: String? { __data["profileDescription"] }
        }

        /// MiraAdded.Location
        ///
        /// Parent Type: `Location`
        public struct Location: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Location }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
            .field("latitude", Double.self),
            .field("longitude", Double.self),
            .field("elevation", Double?.self),
            .field("heading", Double?.self),
          ] }

          public var id: MirageAPI.ID { __data["id"] }
          public var latitude: Double { __data["latitude"] }
          public var longitude: Double { __data["longitude"] }
          public var elevation: Double? { __data["elevation"] }
          public var heading: Double? { __data["heading"] }
        }

        /// MiraAdded.Collector
        ///
        /// Parent Type: `User`
        public struct Collector: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
            .field("phone", String?.self),
            .field("username", String.self),
            .field("profileImage", String?.self),
            .field("profileDescription", String?.self),
          ] }

          public var id: MirageAPI.ID { __data["id"] }
          public var phone: String? { __data["phone"] }
          public var username: String { __data["username"] }
          public var profileImage: String? { __data["profileImage"] }
          public var profileDescription: String? { __data["profileDescription"] }
        }
      }
    }
  }

}