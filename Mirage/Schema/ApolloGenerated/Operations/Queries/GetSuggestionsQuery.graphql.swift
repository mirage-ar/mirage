// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension MirageAPI {
  class GetSuggestionsQuery: GraphQLQuery {
    static let operationName: String = "GetSuggestionsQuery"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetSuggestionsQuery($phoneNumbers: [String!]!) { getExistingUsers(phoneNumbers: $phoneNumbers) { __typename id phone username profileImage profileDescription friendshipStatus } }"#
      ))

    public var phoneNumbers: [String]

    public init(phoneNumbers: [String]) {
      self.phoneNumbers = phoneNumbers
    }

    public var __variables: Variables? { ["phoneNumbers": phoneNumbers] }

    struct Data: MirageAPI.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { MirageAPI.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getExistingUsers", [GetExistingUser?]?.self, arguments: ["phoneNumbers": .variable("phoneNumbers")]),
      ] }

      var getExistingUsers: [GetExistingUser?]? { __data["getExistingUsers"] }

      /// GetExistingUser
      ///
      /// Parent Type: `User`
      struct GetExistingUser: MirageAPI.SelectionSet {
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