// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension MirageAPI {
  class GetMirasQuery: GraphQLQuery {
    public static let operationName: String = "GetMiras"
    public static let document: ApolloAPI.DocumentType = .notPersisted(
      definition: .init(
        #"""
        query GetMiras($getMirasQueryInput: GetMirasQueryInput!) {
          getMiras(input: $getMirasQueryInput) {
            __typename
            id
            creator {
              __typename
              id
              profileImage
              profileImageDesaturated
              username
            }
            location {
              __typename
              latitude
              longitude
            }
            viewed
            collected
            isFriend
          }
        }
        """#
      ))

    public var getMirasQueryInput: GetMirasQueryInput

    public init(getMirasQueryInput: GetMirasQueryInput) {
      self.getMirasQueryInput = getMirasQueryInput
    }

    public var __variables: Variables? { ["getMirasQueryInput": getMirasQueryInput] }

    public struct Data: MirageAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Query }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("getMiras", [GetMira?]?.self, arguments: ["input": .variable("getMirasQueryInput")]),
      ] }

      public var getMiras: [GetMira?]? { __data["getMiras"] }

      /// GetMira
      ///
      /// Parent Type: `Mira`
      public struct GetMira: MirageAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("id", MirageAPI.ID.self),
          .field("creator", Creator.self),
          .field("location", Location.self),
          .field("viewed", Bool.self),
          .field("collected", Bool.self),
          .field("isFriend", Bool.self),
        ] }

        public var id: MirageAPI.ID { __data["id"] }
        public var creator: Creator { __data["creator"] }
        public var location: Location { __data["location"] }
        public var viewed: Bool { __data["viewed"] }
        public var collected: Bool { __data["collected"] }
        public var isFriend: Bool { __data["isFriend"] }

        /// GetMira.Creator
        ///
        /// Parent Type: `User`
        public struct Creator: MirageAPI.SelectionSet {
          public let __data: DataDict
          public init(data: DataDict) { __data = data }

          public static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("id", MirageAPI.ID.self),
            .field("profileImage", String?.self),
            .field("profileImageDesaturated", String?.self),
            .field("username", String.self),
          ] }

          public var id: MirageAPI.ID { __data["id"] }
          public var profileImage: String? { __data["profileImage"] }
          public var profileImageDesaturated: String? { __data["profileImageDesaturated"] }
          public var username: String { __data["username"] }
        }

        /// GetMira.Location
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