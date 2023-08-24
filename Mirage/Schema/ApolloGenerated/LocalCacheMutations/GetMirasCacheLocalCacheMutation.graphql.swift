// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class GetMirasCacheLocalCacheMutation: LocalCacheMutation {
    public static let operationType: GraphQLOperationType = .query

    public var getMirasQueryInput: GetMirasQueryInput

    public init(getMirasQueryInput: GetMirasQueryInput) {
      self.getMirasQueryInput = getMirasQueryInput
    }

    public var __variables: GraphQLOperation.Variables? { ["getMirasQueryInput": getMirasQueryInput] }

    public struct Data: MirageAPI.MutableSelectionSet {
      public var __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("getMiras", [GetMira?]?.self, arguments: ["input": .variable("getMirasQueryInput")]),
      ] }

      public var getMiras: [GetMira?]? {
        get { __data["getMiras"] }
        set { __data["getMiras"] = newValue }
      }

      /// GetMira
      ///
      /// Parent Type: `Mira`
      public struct GetMira: MirageAPI.MutableSelectionSet {
        public var __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", MirageAPI.ID.self),
          .field("miraMedia", [MiraMedium].self),
          .field("creator", Creator.self),
          .field("location", Location.self),
          .field("viewed", Bool.self),
          .field("isFriend", Bool.self),
          .field("collectors", [Collector?].self),
        ] }

        public var id: MirageAPI.ID {
          get { __data["id"] }
          set { __data["id"] = newValue }
        }
        public var miraMedia: [MiraMedium] {
          get { __data["miraMedia"] }
          set { __data["miraMedia"] = newValue }
        }
        public var creator: Creator {
          get { __data["creator"] }
          set { __data["creator"] = newValue }
        }
        public var location: Location {
          get { __data["location"] }
          set { __data["location"] = newValue }
        }
        public var viewed: Bool {
          get { __data["viewed"] }
          set { __data["viewed"] = newValue }
        }
        public var isFriend: Bool {
          get { __data["isFriend"] }
          set { __data["isFriend"] = newValue }
        }
        public var collectors: [Collector?] {
          get { __data["collectors"] }
          set { __data["collectors"] = newValue }
        }

        /// GetMira.MiraMedium
        ///
        /// Parent Type: `ArMedia`
        public struct MiraMedium: MirageAPI.MutableSelectionSet {
          public var __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.ArMedia }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("contentType", GraphQLEnum<MirageAPI.ContentType>.self),
            .field("assetUrl", String.self),
            .field("shape", GraphQLEnum<MirageAPI.Shape>.self),
            .field("position", Position.self),
            .field("modifier", Modifier?.self),
          ] }

          public var contentType: GraphQLEnum<MirageAPI.ContentType> {
            get { __data["contentType"] }
            set { __data["contentType"] = newValue }
          }
          public var assetUrl: String {
            get { __data["assetUrl"] }
            set { __data["assetUrl"] = newValue }
          }
          public var shape: GraphQLEnum<MirageAPI.Shape> {
            get { __data["shape"] }
            set { __data["shape"] = newValue }
          }
          public var position: Position {
            get { __data["position"] }
            set { __data["position"] = newValue }
          }
          public var modifier: Modifier? {
            get { __data["modifier"] }
            set { __data["modifier"] = newValue }
          }

          /// GetMira.MiraMedium.Position
          ///
          /// Parent Type: `Position`
          public struct Position: MirageAPI.MutableSelectionSet {
            public var __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Position }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("id", MirageAPI.ID.self),
              .field("transform", [[Double]].self),
            ] }

            public var id: MirageAPI.ID {
              get { __data["id"] }
              set { __data["id"] = newValue }
            }
            public var transform: [[Double]] {
              get { __data["transform"] }
              set { __data["transform"] = newValue }
            }
          }

          /// GetMira.MiraMedium.Modifier
          ///
          /// Parent Type: `Modifier`
          public struct Modifier: MirageAPI.MutableSelectionSet {
            public var __data: DataDict
            public init(data: DataDict) { __data = data }

            public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Modifier }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("id", MirageAPI.ID.self),
              .field("type", GraphQLEnum<MirageAPI.ModifierType>.self),
              .field("amount", Double.self),
            ] }

            public var id: MirageAPI.ID {
              get { __data["id"] }
              set { __data["id"] = newValue }
            }
            public var type: GraphQLEnum<MirageAPI.ModifierType> {
              get { __data["type"] }
              set { __data["type"] = newValue }
            }
            public var amount: Double {
              get { __data["amount"] }
              set { __data["amount"] = newValue }
            }
          }
        }

        /// GetMira.Creator
        ///
        /// Parent Type: `User`
        public struct Creator: MirageAPI.MutableSelectionSet {
          public var __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
            .field("phone", String?.self),
            .field("username", String.self),
            .field("profileImage", String?.self),
            .field("profileDescription", String?.self),
          ] }

          public var id: MirageAPI.ID {
            get { __data["id"] }
            set { __data["id"] = newValue }
          }
          public var phone: String? {
            get { __data["phone"] }
            set { __data["phone"] = newValue }
          }
          public var username: String {
            get { __data["username"] }
            set { __data["username"] = newValue }
          }
          public var profileImage: String? {
            get { __data["profileImage"] }
            set { __data["profileImage"] = newValue }
          }
          public var profileDescription: String? {
            get { __data["profileDescription"] }
            set { __data["profileDescription"] = newValue }
          }
        }

        /// GetMira.Location
        ///
        /// Parent Type: `Location`
        public struct Location: MirageAPI.MutableSelectionSet {
          public var __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Location }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
            .field("latitude", Double.self),
            .field("longitude", Double.self),
            .field("elevation", Double?.self),
          ] }

          public var id: MirageAPI.ID {
            get { __data["id"] }
            set { __data["id"] = newValue }
          }
          public var latitude: Double {
            get { __data["latitude"] }
            set { __data["latitude"] = newValue }
          }
          public var longitude: Double {
            get { __data["longitude"] }
            set { __data["longitude"] = newValue }
          }
          public var elevation: Double? {
            get { __data["elevation"] }
            set { __data["elevation"] = newValue }
          }
        }

        /// GetMira.Collector
        ///
        /// Parent Type: `User`
        public struct Collector: MirageAPI.MutableSelectionSet {
          public var __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
            .field("phone", String?.self),
            .field("username", String.self),
            .field("profileImage", String?.self),
            .field("profileDescription", String?.self),
          ] }

          public var id: MirageAPI.ID {
            get { __data["id"] }
            set { __data["id"] = newValue }
          }
          public var phone: String? {
            get { __data["phone"] }
            set { __data["phone"] = newValue }
          }
          public var username: String {
            get { __data["username"] }
            set { __data["username"] = newValue }
          }
          public var profileImage: String? {
            get { __data["profileImage"] }
            set { __data["profileImage"] = newValue }
          }
          public var profileDescription: String? {
            get { __data["profileDescription"] }
            set { __data["profileDescription"] = newValue }
          }
        }
      }
    }
  }

}