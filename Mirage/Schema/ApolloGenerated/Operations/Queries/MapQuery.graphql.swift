// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class MapQuery: GraphQLQuery {
    public static let operationName: String = "Map"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query Map($mapQueryInput: MapQueryInput!) {
          map(input: $mapQueryInput) {
            __typename
            id
            creator {
              __typename
              id
              pfp
              username
            }
            location {
              __typename
              latitude
              longitude
            }
            viewed
            collected
          }
        }
        """#
      ))

    public var mapQueryInput: MapQueryInput

    public init(mapQueryInput: MapQueryInput) {
      self.mapQueryInput = mapQueryInput
    }

    public var __variables: Variables? { ["mapQueryInput": mapQueryInput] }

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("map", [Map?]?.self, arguments: ["input": .variable("mapQueryInput")]),
      ] }

      public var map: [Map?]? { __data["map"] }

      /// Map
      ///
      /// Parent Type: `Mira`
      public struct Map: MirageAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", MirageAPI.ID.self),
          .field("creator", Creator.self),
          .field("location", Location.self),
          .field("viewed", Bool.self),
          .field("collected", Bool.self),
        ] }

        public var id: MirageAPI.ID { __data["id"] }
        public var creator: Creator { __data["creator"] }
        public var location: Location { __data["location"] }
        public var viewed: Bool { __data["viewed"] }
        public var collected: Bool { __data["collected"] }

        /// Map.Creator
        ///
        /// Parent Type: `User`
        public struct Creator: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
            .field("pfp", String?.self),
            .field("username", String.self),
          ] }

          public var id: MirageAPI.ID { __data["id"] }
          public var pfp: String? { __data["pfp"] }
          public var username: String { __data["username"] }
        }

        /// Map.Location
        ///
        /// Parent Type: `Location`
        public struct Location: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Location }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("latitude", Double.self),
            .field("longitude", Double.self),
          ] }

          public var latitude: Double { __data["latitude"] }
          public var longitude: Double { __data["longitude"] }
        }
      }
    }
  }

}