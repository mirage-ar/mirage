// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class AddMiraMutation: GraphQLMutation {
    public static let operationName: String = "AddMira"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        mutation AddMira($addMiraInput: AddMiraInput!) {
          addMira(input: $addMiraInput) {
            __typename
            id
            miraMedia {
              __typename
              assetUrl
              contentType
              shape
              modifier {
                __typename
                id
                type
              }
              position {
                __typename
                id
                transform
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
              latitude
              longitude
              elevation
              heading
            }
          }
        }
        """#
      ))

    public var addMiraInput: AddMiraInput

    public init(addMiraInput: AddMiraInput) {
      self.addMiraInput = addMiraInput
    }

    public var __variables: Variables? { ["addMiraInput": addMiraInput] }

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("addMira", AddMira?.self, arguments: ["input": .variable("addMiraInput")]),
      ] }

      public var addMira: AddMira? { __data["addMira"] }

      /// AddMira
      ///
      /// Parent Type: `Mira`
      public struct AddMira: MirageAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", MirageAPI.ID.self),
          .field("miraMedia", [MiraMedium]?.self),
          .field("creator", Creator?.self),
          .field("location", Location?.self),
        ] }

        public var id: MirageAPI.ID { __data["id"] }
        public var miraMedia: [MiraMedium]? { __data["miraMedia"] }
        public var creator: Creator? { __data["creator"] }
        public var location: Location? { __data["location"] }

        /// AddMira.MiraMedium
        ///
        /// Parent Type: `ArMedia`
        public struct MiraMedium: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.ArMedia }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("assetUrl", String.self),
            .field("contentType", GraphQLEnum<MirageAPI.ContentType>.self),
            .field("shape", GraphQLEnum<MirageAPI.Shape>.self),
            .field("modifier", Modifier?.self),
            .field("position", Position?.self),
          ] }

          public var assetUrl: String { __data["assetUrl"] }
          public var contentType: GraphQLEnum<MirageAPI.ContentType> { __data["contentType"] }
          public var shape: GraphQLEnum<MirageAPI.Shape> { __data["shape"] }
          public var modifier: Modifier? { __data["modifier"] }
          public var position: Position? { __data["position"] }

          /// AddMira.MiraMedium.Modifier
          ///
          /// Parent Type: `Modifier`
          public struct Modifier: MirageAPI.SelectionSet {
            public let __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Modifier }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("id", MirageAPI.ID.self),
              .field("type", GraphQLEnum<MirageAPI.ModifierType>.self),
            ] }

            public var id: MirageAPI.ID { __data["id"] }
            public var type: GraphQLEnum<MirageAPI.ModifierType> { __data["type"] }
          }

          /// AddMira.MiraMedium.Position
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
        }

        /// AddMira.Creator
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

        /// AddMira.Location
        ///
        /// Parent Type: `Location`
        public struct Location: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Location }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("latitude", Double.self),
            .field("longitude", Double.self),
            .field("elevation", Double?.self),
            .field("heading", Double?.self),
          ] }

          public var latitude: Double { __data["latitude"] }
          public var longitude: Double { __data["longitude"] }
          public var elevation: Double? { __data["elevation"] }
          public var heading: Double? { __data["heading"] }
        }
      }
    }
  }

}