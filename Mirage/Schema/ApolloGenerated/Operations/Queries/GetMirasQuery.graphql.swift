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
            creator {
              __typename
              id
              profileImage
              profileImageDesaturated
              profileDescription
              username
            }
            location {
              __typename
              latitude
              longitude
            }
            viewed
            isFriend
            collectors {
              __typename
              id
              profileImage
              profileImageDesaturated
              profileDescription
              username
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
      init(_dataDict: DataDict) { __data = _dataDict }

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
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Mira }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", MirageAPI.ID.self),
          .field("creator", Creator.self),
          .field("location", Location.self),
          .field("viewed", Bool.self),
          .field("isFriend", Bool.self),
          .field("collectors", [Collector?].self),
        ] }

        var id: MirageAPI.ID { __data["id"] }
        var creator: Creator { __data["creator"] }
        var location: Location { __data["location"] }
        var viewed: Bool { __data["viewed"] }
        var isFriend: Bool { __data["isFriend"] }
        var collectors: [Collector?] { __data["collectors"] }

        /// GetMira.Creator
        ///
        /// Parent Type: `User`
        struct Creator: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
            .field("profileImage", String?.self),
            .field("profileImageDesaturated", String?.self),
            .field("profileDescription", String?.self),
            .field("username", String.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
          var profileImage: String? { __data["profileImage"] }
          var profileImageDesaturated: String? { __data["profileImageDesaturated"] }
          var profileDescription: String? { __data["profileDescription"] }
          var username: String { __data["username"] }
        }

        /// GetMira.Location
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
          ] }

          var latitude: Double { __data["latitude"] }
          var longitude: Double { __data["longitude"] }
        }

        /// GetMira.Collector
        ///
        /// Parent Type: `User`
        struct Collector: MirageAPI.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.User }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", MirageAPI.ID.self),
            .field("profileImage", String?.self),
            .field("profileImageDesaturated", String?.self),
            .field("profileDescription", String?.self),
            .field("username", String.self),
          ] }

          var id: MirageAPI.ID { __data["id"] }
          var profileImage: String? { __data["profileImage"] }
          var profileImageDesaturated: String? { __data["profileImageDesaturated"] }
          var profileDescription: String? { __data["profileDescription"] }
          var username: String { __data["username"] }
        }
      }
    }
  }

}